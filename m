Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaETRKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:10:31 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:45812 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaETRKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:10:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AioWAMaLe1NbsnsG/2dsb2JhbABPCoMGqwwBAQEBAQEFAYM6lm4CAgGBGxd0giUBAQQBJxM/BQsIAxguOR4GE4g5DAHUExeFVYgVAgYLAVAHhEABA488iisBkyCDOjuBMQkX
Date: Tue, 20 May 2014 19:10:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kurt Garloff <garloff@suse.de>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by ilog2
Message-Id: <20140520191028.8caf5ddb7938f5803fb17536@skynet.be>
In-Reply-To: <1400605602.26709.11.camel@joe-AO725>
References: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>
	<1400605602.26709.11.camel@joe-AO725>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 10:06:42 -0700
Joe Perches <joe@perches.com> wrote:

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
> If so, that should be mentioned in the changelog.
> 
> These should probably add #include <linux/log2.h>
> 
> It would have been nicer to use a patch series
> and a cover letter so I could make this reply to
> to cover letter.
> 
> Please take the time to setup and use git send-email
> instead of sylpheed.
> 
Hello Joe,

   Ok, I'll send a new version in patchset mode.

Fabian

> 
