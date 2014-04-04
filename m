Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaDDT4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:56:20 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:54459 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754119AbaDDT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:56:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1362:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:4321:4605:5007:6119:7652:7903:9121:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12740:13069:13071:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grade19_36d10c20a3558
X-Filterd-Recvd-Size: 2323
Message-ID: <1396641375.2863.18.camel@joe-AO722>
Subject: Re: [PATCH 1/1] staging: comedi: Fix checkpatch warning
From: Joe Perches <joe@perches.com>
To: Camille Begue <camille.begue44@gmail.com>
Cc: devel@driverdev.osuosl.org, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 04 Apr 2014 12:56:15 -0700
In-Reply-To: <1396638941-16099-1-git-send-email-camille.begue44@gmail.com>
References: <1396638941-16099-1-git-send-email-camille.begue44@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 21:15 +0200, Camille Begue wrote:
> This patch is part of eudyptula challenge

Hello Camille.

Please do not write commit log messages like this.
Say what's wrong with the code, not why you did it.

Write something like:

Wrap lines > 80 columns.

> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
[]
> @@ -1435,13 +1435,16 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
>  	s = &dev->subdevices[cmd->subdev];
>  
>  	if (s->type == COMEDI_SUBD_UNUSED) {
> -		dev_dbg(dev->class_dev, "%d not valid subdevice\n", cmd->subdev);
> +		dev_dbg(dev->class_dev,
> +			"%d not valid subdevice\n",
> +			cmd->subdev);

If you really want to fix > 80 column lines, it'd be
better to keep the dev_dbg and format on the same line

         1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890
		dev_dbg(dev->class_dev, "%d not valid subdevice\n",
			cmd->subdev);

>  		return -EIO;
>  	}
>  
>  	if (!s->do_cmd || !s->do_cmdtest || !s->async) {
>  		dev_dbg(dev->class_dev,
> -			"subdevice %d does not support commands\n", cmd->subdev);
> +			"subdevice %d does not support commands\n",
> +			cmd->subdev);
>  		return -EIO;
>  	}
>  

here too


