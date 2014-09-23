Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaIWVjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:39:25 -0400
Received: from mail.us.es ([193.147.175.20]:44162 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbaIWVjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:39:23 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19423. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 2.040677 secs); 23 Sep 2014 21:39:20 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 23 Sep 2014 23:40:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: Rob Jones <rob.jones@codethink.co.uk>, davem@davemloft.net,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@codethink.co.uk, linux-kernel@vger.kernel.org,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [Linux-kernel] [PATCH v2] net/netfilter/x_tables.c: use
 __seq_open_private()
Message-ID: <20140923214021.GA4206@salvia>
References: <1411491955-9131-1-git-send-email-rob.jones@codethink.co.uk>
 <1411494387.32579.138.camel@xylophone>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411494387.32579.138.camel@xylophone>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:46:27PM +0100, Ben Hutchings wrote:
> On Tue, 2014-09-23 at 18:05 +0100, Rob Jones wrote:
> > Reduce boilerplate code by using __seq_open_private() instead of seq_open()
> > in xt_match_open() and xt_target_open().
> > 
> > Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> > ---
> > 
> > This patch uses an existing variant of seq_open() to reduce the kernel code
> > size.
> > 
> > The only significant variation from the pre-existing code is the fact that
> > __seq_open_private() calls kzalloc() rather than kmalloc(), which could
> > conceivably have an impact on timing.
> > 
> > This version 2 incorporates a minor initialisation simplification (resulting
> > from kzalloc() being used) requested by netfilter-devel@vger.kernel.org
> [...]
> > --- a/net/netfilter/x_tables.c
> > +++ b/net/netfilter/x_tables.c
> > @@ -1080,7 +1080,6 @@ static void *xt_mttg_seq_start(struct seq_file *seq, loff_t *pos,
> >         struct nf_mttg_trav *trav = seq->private;
> >         unsigned int j;
> >  
> > -       trav->class = MTTG_TRAV_INIT;
> >         for (j = 0; j < *pos; ++j)
> >                 if (xt_mttg_seq_next(seq, NULL, NULL, is_target) == NULL)
> >                         return NULL;
> [...]
> 
> I'm fairly sure this simplification is wrong, as xt_mttg_seq_start() is
> potentially called multiple times on the same file handle.

Right. I'm going to take v1 of this patch instead, sorry for the
inconvenience Rob.
