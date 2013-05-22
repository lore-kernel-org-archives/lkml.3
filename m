Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3EVNZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:25:31 -0400
Received: from mxout1.idt.com ([157.165.5.25]:52556 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3EVNZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:25:28 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Jean Delvare <jdelvare@suse.de>, Matt Porter <mporter@kernel.crashing.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: RapidIO subsystem and modularity
Thread-Topic: RapidIO subsystem and modularity
Thread-Index: AQHOVumgeKzD697YeUqgCYNfc4bXy5kRLClw
Date: Wed, 22 May 2013 13:24:24 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BC34265@corpmail1.na.ads.idt.com>
References: <1369226430.4718.123.camel@chaos.site>
In-Reply-To: <1369226430.4718.123.camel@chaos.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4MDPgL1028514

Hello Jean,

You have got really good time for this question.

We are working on RapidIO modularization right now. Drivers for switches are converted already and patches are planned to be submitted quite soon. After that we will work on mports and core itself (or maybe publish all things together). At this moment all switch initialization is reworked to be the standard module initialization and that built-in initialization magic is gone ;). Tsi721 driver should not be a problem to build as a module. We consider this modularization work as part of adding hot-plug support into RapidIO but modularization of the existing functionality may be published as a first step.

RapidIO has its primary use in embedded systems (wireless, military, medical etc.) where fast low-latency data transfers are required. It also may be used in high-performance storage systems. I do not think that it may be useful on standard desktop workstation (except demo and development work). Other distributions keep it disabled and we are fine with this. Most of RapidIO use at this time involves embedded powerpc platforms with x86(_64) picking up thanks to availability of Tsi721.

Regards,

Alex.

> -----Original Message-----
> From: Jean Delvare [mailto:jdelvare@suse.de]
> Sent: Wednesday, May 22, 2013 8:41 AM
> To: Matt Porter; Bounine, Alexandre
> Cc: Andrew Morton; linux-kernel
> Subject: RapidIO subsystem and modularity
> 
> Hi Matt, Alexandre, Andrew,
> 
> At the moment all pieces of the RapidIO subsystem are defined as bool
> and thus cannot be built as modules. This is a problem for distribution
> kernels, which are left with only two choices: disable RapidIO
> altogether (too bad if any user actually needed it), or enable it all
> (and waste memory and initialization time for every user without the
> hardware - most users as I understand it.)
> 
> I don't even know what RapidIO is good for. I read about it on the web
> but I have to admit I still have no clear idea, what systems use this
> technology.
> 
> This leads me to two questions:
> 
> 1* Is there a fundamental reason why (at least the device-specific
> parts
> of) RapidIO can't be modularized?
> 
> FWIW I tried making the device drivers (tsi721) modular and it builds
> and links OK, but I suppose one would have implement a proper remove
> function, otherwise module unloading will break.
> 
> I also tried making the switch drivers (tsi57x etc.) modular, all build
> just fine without any change, but there seems to be some initialization
> magic which may not work when the code is built as modules.
> 
> 2* What systems are expected to use RapidIO? It is enabled in the i386,
> x86_64, ppc and ppc64 generic openSUSE kernel configurations. If
> someone
> tells me that some or all of these generic kernels would never be used
> on systems which need RapidIO support, I would be happy to disable
> RapidIO support from these kernels, to make them smaller and decrease
> boot times.
> 
> Thanks for any insight,
> --
> Jean Delvare
> Suse L3

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
