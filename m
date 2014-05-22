Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaEVA2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:28:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59300 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaEVA2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:28:37 -0400
Date: Wed, 21 May 2014 17:28:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kurt Garloff <garloff@suse.de>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by ilog2
Message-ID: <20140522002822.GA6446@roeck-us.net>
References: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>
 <1400605602.26709.11.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400605602.26709.11.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:06:42AM -0700, Joe Perches wrote:
> On Tue, 2014-05-20 at 18:48 +0200, Fabian Frederick wrote:
> > Cc: Kurt Garloff <garloff@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  drivers/scsi/tmscsim.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> []
> > @@ -1611,7 +1611,7 @@ dc390_Reselect( struct dc390_acb* pACB )
> >        printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
> >      else
> >        lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
> > -    id = 0; while (lun >>= 1) id++;
> > +    id = ilog2(lun);
> >      /* Get LUN */
> >      lun = DC390_read8 (ScsiFifo);
> >      if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
> 
> Hey Fabian.
> 
> You've submitted several of these now.
> 
> Have you gone through all of these to make sure
> that the ilog2(<foo>) uses are always using a
> non-zero <foo>?
> 
Maybe I am missing something. Why not just use fls() ?

Guenter
