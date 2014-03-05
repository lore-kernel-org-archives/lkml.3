Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbaCEBoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:44:06 -0500
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:40263 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754105AbaCEBoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:44:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:4250:4321:4362:4605:5007:7652:9149:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12555:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: foot07_7aa6d58f40745
X-Filterd-Recvd-Size: 2314
Message-ID: <1393983841.3271.19.camel@joe-AO722>
Subject: Re: [PATCH 2/2] staging :keucr:scsiglue.c : fixed a macros should
 not be colon terminated issue
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Keerthimai Janarthanan <keerthimaipb@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2014 17:44:01 -0800
In-Reply-To: <20140305011054.GA10990@kroah.com>
References: <1393764677-4709-1-git-send-email-keerthimaipb@gmail.com>
	 <20140305011054.GA10990@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 17:10 -0800, Greg KH wrote:
> On Sun, Mar 02, 2014 at 06:21:16PM +0530, Keerthimai Janarthanan wrote:
> > fixed a coding style issue.
[]
> > diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
[]
> > @@ -277,7 +277,7 @@ static int show_info(struct seq_file *m, struct Scsi_Host *host)
> >  	do { \
> >  		if (us->fflags & value) \
> >  			SPRINTF(" " #name); \
> > -	} while (0);
> > +	} while (0)
> 
> You just broke the build.
> 
> Please ALWAYS test your patches, don't break someone else's build with
> broken patches...
> 
> Please be more careful.

Thanks Greg.

Keerthimai, a possibly "better" fix would be to add a
do { ... } while (0) guard and semicolons to the relatively
ugly US_DO_ALL_FLAGS macro and US_FLAG uses in
include/linux/usb_usual.h

include/linux/usb_usual.h:#define US_DO_ALL_FLAGS                                               \
include/linux/usb_usual.h-      US_FLAG(SINGLE_LUN,     0x00000001)                     \
include/linux/usb_usual.h-              /* allow access to only LUN 0 */                \
include/linux/usb_usual.h-      US_FLAG(NEED_OVERRIDE,  0x00000002)                     \
include/linux/usb_usual.h-              /* unusual_devs entry is necessary */           \
...

and then add a semicolon to the uses of US_DO_ALL_FLAGS
and then remove a semicolon as above.

