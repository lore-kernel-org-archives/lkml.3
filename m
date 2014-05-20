Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaETRGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:06:50 -0400
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:43476 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753534AbaETRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:06:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:4321:4605:5007:6248:7652:7901:8957:9040:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone53_57e7aff746d11
X-Filterd-Recvd-Size: 2160
Message-ID: <1400605602.26709.11.camel@joe-AO725>
Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by ilog2
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kurt Garloff <garloff@suse.de>, akpm <akpm@linux-foundation.org>
Date: Tue, 20 May 2014 10:06:42 -0700
In-Reply-To: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>
References: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


