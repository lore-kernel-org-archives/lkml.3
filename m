Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaDDP2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:28:16 -0400
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:46927 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753472AbaDDP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:28:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3871:3872:3873:4250:4321:4605:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spoon82_2a1ec4efa8a60
X-Filterd-Recvd-Size: 2392
Message-ID: <1396625287.2863.4.camel@joe-AO722>
Subject: Re: [PATCH] staging: comedi: drivers: pcl812.c: fixed a coding
 style issue
From: Joe Perches <joe@perches.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, wharms@bfs.de,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Apr 2014 08:28:07 -0700
In-Reply-To: <20140404151756.GA14330@gmail.com>
References: <1396605929-10514-1-git-send-email-gmate.amit@gmail.com>
	 <20140404110707.GT6991@mwanda> <20140404114852.GA12452@gmail.com>
	 <20140404132651.GV6991@mwanda> <20140404151756.GA14330@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 18:17 +0300, Kumar Amit Mehta wrote:
> What Walter mentioned also makes sense, So shouldn't it be something
> like this:

I'm not Dan, but:

> [amit@localhost linux-next]$ git diff
> diff --git a/drivers/staging/comedi/drivers/pcl812.c
> b/drivers/staging/comedi/drivers/pcl812.c
> index 160eac8..552b696 100644
> --- a/drivers/staging/comedi/drivers/pcl812.c
> +++ b/drivers/staging/comedi/drivers/pcl812.c
> @@ -803,16 +803,14 @@ static int pcl812_ai_cmd(struct comedi_device
> *dev, struct comedi_subdevice *s)
>  
>         pcl812_ai_set_chan_range(dev, cmd->chanlist[0], 1);
>  
> +       devpriv->ai_dma = 0;
>         if (devpriv->dma) {     /*  check if we can use DMA transfer */
>                 devpriv->ai_dma = 1;
>                 for (i = 1; i < cmd->chanlist_len; i++)
>                         if (cmd->chanlist[0] != cmd->chanlist[i]) {
>                                 /*  we cann't use DMA :-( */
> -                               devpriv->ai_dma = 0;

No.

You enable unwanted DMA capability here.
There's a typo of can't too.

>                                 break;
>                         }
> -       } else
> -               devpriv->ai_dma = 0;

Otherwise, I suppose either style is OK.

