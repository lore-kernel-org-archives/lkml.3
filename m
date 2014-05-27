Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaE0HD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:03:59 -0400
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:52751 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751720AbaE0HD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:03:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3866:3867:3868:3870:3871:3872:3873:4250:4321:4605:5007:6119:7514:7522:7576:7652:7875:7901:8957:10004:10400:10848:11232:11658:11914:12043:12291:12296:12517:12519:12555:12683:12740:13071:13095:13161:13229:14110:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gold55_226d3084fda0f
X-Filterd-Recvd-Size: 3088
Message-ID: <1401174235.18413.8.camel@joe-AO725>
Subject: Re: [PATCH] This is my first commit
From: Joe Perches <joe@perches.com>
To: hnnnet48@gmail.com
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 00:03:55 -0700
In-Reply-To: <1401173061-6500-1-git-send-email-hnnnet48@gmail.com>
References: <1401173061-6500-1-git-send-email-hnnnet48@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 14:44 +0800, hnnnet48@gmail.com wrote:
> From: kevin <hnnnet48@gmail.com>

Hi Kevin.

You subject line should be something like:
[PATCH] Add support for GeneralTouch serial screen

There should be a commit message too.

> ---
>  gtserio.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

In what directory should this file be placed?
Will you submit a Makefile/Kconfig mechanism to make it?

You should run your patch through scripts/checkpatch.pl
It will flag a number of things you should consider fixing.

>  create mode 100755 gtserio.c

755 is not correct.  644 please.

> diff --git a/gtserio.c b/gtserio.c
[]
> + *  gtserio.c - Create an input/output character device for GeneralTouch serial screen
[]
> +MODULE_AUTHOR("GeneralTouch <support@generaltouch.com>");

Kevin, do you work for generaltouch
or did you get this file from somewhere?

> +static int Device_Open = 0;
> +struct input_dev *devq;
> +char Message[BUF_LEN];
> +dev_t gts_t;
> +unsigned char val[10];
> +int gtsdata[4];
> +unsigned long min_x = 0;
> +unsigned long max_x = 32767;
> +unsigned long min_y = 0;
> +unsigned long max_y = 32767;

All of these should probably be static.

> +char *Message_Ptr;

CamelCase is not generally used in linux-kernel.

> +static int device_open(struct inode *inode, struct file *file)
> +{
> +	printk("GTS device_open(%p)\n", file);

printk should use a KERN_<LEVEL>

> +
> +#ifdef DEBUG
> +	printk("device_open(%p)\n", file);
> +#endif

Unnecessary duplication, this DEBUG should be removed.

> +static int device_release(struct inode *inode, struct file *file)
> +{
> +#ifdef DEBUG
> +	printk("device_release(%p,%p)\n", inode, file);
> +#endif

pr_debug is used instead of
#ifdef DEBUG
	printk(foo...)
#endif

> +	return SUCCESS;

	return 0;

instead of a somewhat unnecessary #define


> +	printk("val[3] = %x,val[4] = %x\nval[5] = %x,val[6] = %x\n", val[3],
> +	       val[4], val[5], val[6]);

I suspect this should be pr_debug too.

> +	gtsdata[0] = val[2];
> +	gtsdata[1] = (val[4] << 8) | (val[3]);
> +	gtsdata[2] = (val[6] << 8) | (val[5]);
> +	gtsdata[3] = val[9];
> +	printk("gtsdata[1] = %x\ngtsdata[2] = %x\n", gtsdata[1], gtsdata[2]);

and this


