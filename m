Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaETRNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:13:09 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:59578 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752085AbaETRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:13:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:602:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2689:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6248:7576:7652:7875:7901:8957:9025:9040:9072:9388:9545:10004:10049:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13019:13071:13095:13161:13163:13229:13436,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: side28_8f234f8fa670f
X-Filterd-Recvd-Size: 2825
Message-ID: <1400605982.26709.15.camel@joe-AO725>
Subject: [Fwd: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by
 ilog2]
From: Joe Perches <joe@perches.com>
To: Kurt Garloff <kurt@garloff.de>
Cc: Fabian Frederick <fabf@skynet.be>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 May 2014 10:13:02 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kurt.

If you're still interested in tmscim.

Your garloff@suse.de address bounces....

btw:  Your MAINTAINERS entry is out of date.

MAINTAINERS-DC390/AM53C974 SCSI driver
MAINTAINERS:M:  Kurt Garloff <garloff@suse.de>
MAINTAINERS:W:  http://www.garloff.de/kurt/linux/dc390/
MAINTAINERS-M:  Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MAINTAINERS-S:  Maintained
MAINTAINERS-F:  drivers/scsi/tmscsim.*

-------- Forwarded Message --------
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Kurt Garloff
<garloff@suse.de>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by
ilog2

On Tue, 2014-05-20 at 18:48 +0200, Fabian Frederick wrote:
> Cc: Kurt Garloff <garloff@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/scsi/tmscsim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
[]
> @@ -1611,7 +1611,7 @@ dc390_Reselect( struct dc390_acb* pACB )
>        printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
>      else
>        lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
> -    id = 0; while (lun >>= 1) id++;
> +    id = ilog2(lun);
>      /* Get LUN */
>      lun = DC390_read8 (ScsiFifo);
>      if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");

Hey Fabian.

You've submitted several of these now.

Have you gone through all of these to make sure
that the ilog2(<foo>) uses are always using a
non-zero <foo>?

If so, that should be mentioned in the changelog.

These should probably add #include <linux/log2.h>

It would have been nicer to use a patch series
and a cover letter so I could make this reply to
to cover letter.

Please take the time to setup and use git send-email
instead of sylpheed.



