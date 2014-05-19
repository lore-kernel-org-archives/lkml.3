Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaESTmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:42:13 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:43029 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752343AbaESTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:42:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3350:3622:3867:3871:3872:3873:4321:4384:4605:5007:7652:7903:9149:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: balls64_4d0378963c229
X-Filterd-Recvd-Size: 2171
Message-ID: <1400528527.14238.20.camel@joe-AO725>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
From: Joe Perches <joe@perches.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Amit Uttamchandani <auttamchandani@logicube.com>,
        Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 19 May 2014 12:42:07 -0700
In-Reply-To: <CAPybu_0T3GmyTQfPuG3YofkWO_px0fYAyofz2OAab6=9PqsKLQ@mail.gmail.com>
References: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1400526693-29776-6-git-send-email-ricardo.ribalda@gmail.com>
	 <1400526979.14238.16.camel@joe-AO725>
	 <CAPybu_0T3GmyTQfPuG3YofkWO_px0fYAyofz2OAab6=9PqsKLQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 21:33 +0200, Ricardo Ribalda Delgado wrote:
> I think dev_vdg cannot be controlled with DYNAMIC_DEBUG, therefore I
> replaced it with dev_dbg.
> 
> But if you prefer to use dev_dbg, I will modify it to use dev_dbg

s/VDEBUG/dev_vdbg/

dev_vdbg can be controlled by DYNAMIC_DEBUG.

dev_vdbg is dev_dbg when VERBOSE_DEBUG is set.

include/linux/device.h-#ifdef VERBOSE_DEBUG
include/linux/device.h:#define dev_vdbg dev_dbg
include/linux/device.h-#else
include/linux/device.h:#define dev_vdbg(dev, format, arg...)                            \
include/linux/device.h-({                                                               \
include/linux/device.h- if (0)                                                  \
include/linux/device.h-         dev_printk(KERN_DEBUG, dev, format, ##arg);     \
include/linux/device.h- 0;                                                      \
include/linux/device.h-})


