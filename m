Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaETNUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:20:55 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.108]:28964 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbaETNUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:20:54 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-12.tower-200.messagelabs.com!1400592045!16037669!24
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 20 May 2014 08:20:49 -0500
Subject: Re: [PATCH 2/7] staging: unisys: move uislib/platform proc entry to
 debugfs
Thread-Topic: [PATCH 2/7] staging: unisys: move uislib/platform proc entry
 to debugfs
Thread-Index: Ac90LlEbwuXaFHOIS7ezo5YZ3LOUqA==
Message-ID: <C97001BC43954D438ACB059713BA5CDFA47DDAD940@USEA-EXCH7.na.uis.unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
 <1399912715-16142-3-git-send-email-benjamin.romer@unisys.com>
 <20140518164918.GA10285@kroah.com>
 <C97001BC43954D438ACB059713BA5CDFA47DDAD93D@USEA-EXCH7.na.uis.unisys.com>
 <20140519195708.GY15585@mwanda> <20140520010921.GA27462@kroah.com>
In-Reply-To: <20140520010921.GA27462@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4KDL07u012238

On Tue, 2014-05-20 at 10:09 +0900, Greg KH wrote:
> On Mon, May 19, 2014 at 10:57:08PM +0300, Dan Carpenter wrote:
> > On Mon, May 19, 2014 at 09:42:22AM -0500, Romer, Benjamin M wrote:
> > > On Sun, 2014-05-18 at 09:49 -0700, Greg KH wrote:
> > > > Also, why are these entries moving to debugfs at all?  Why are they
> > > > needed?  Who will use them?  Are tools relying on them to be there?
> > > 
> > > The tuning entries are sometimes used to help adjust the behavior of our
> > > IO service partitions for better performance.
> > 
> > That sounds like it really belongs in sysfs instead of debugfs.
> 
> Exactly.  debugfs files are for "debugging".  Consider them files that
> your driver can work properly if no one ever touches them.
> 

That is what I was trying to say - these are used when someone is
changing the behavior of IO service partitions, not the guest partition
where the driver is running. No typical user will need or want to change
these settings - only someone working on the IO *server side*
performance will need access to them. All of our drivers communicate
with another partition to perform IO on shared devices. By turning off
features, or changing the rate of messaging in the channels, it makes it
easier for someone working on the IO service partition to tune the
performance there. The guest itself isn't being tuned.

> "tuning" files imply something that has to be touched by users.
> Ideally, you would never need such a thing as no one wants to have to
> write things to files to make the kernel work better.  

That is indeed what we want - a user should not need to touch these
settings. Someone manipulating these particular settings would be
tweaking performance on the server end, like I was trying to say. I
believe that most of our proc entries are really debug-time tweaks of
that sort, and not something a typical user would ever want to touch.

> But if you really
> need it, they should be sysfs files, with the needed documentation.
> 
> thanks,
> 
> greg k-h

Sorry about the confusion! 

-- 
Ben Romer | Software Engineer |
Virtual Systems Development 

Unisys Corporation |  2476
Swedesford Rd |  Malvern, PA 19355
|  610-648-7140



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
