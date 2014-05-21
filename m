Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaEUQFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:05:04 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64338 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaEUQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:05:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        andriy.shevchenko@intel.com, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 0/2] Add support for the Allwinner A31 DMA Controller
Date: Wed, 21 May 2014 18:04:43 +0200
Message-ID: <5291281.0OW8pVdbhQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521155551.GV27329@lukather>
References: <1400685357-508-1-git-send-email-maxime.ripard@free-electrons.com> <4828893.NoTbcUXQEt@wuerfel> <20140521155551.GV27329@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iJN5x6mFW9SOVYK9WbO1DHBV9bl/AYDZgRcCOyXgvt+
 oOVGIFLNO94eUKTZH3ZlW0Wbpu/NgYPu5K2z+zXljG9Zyv/CxY
 /KfOInpEakMDRgm7pGx491hfBAoL7VnwU4htdIgaj9c3PQg0OB
 p0XoFm8IGzRS1A8zzMBSwTJk1EfZgaQJVn1Zhz9FJBN0uh9yhu
 ee/IFh0IL6SKEBXALow4p/i25Ec7WLDdIjcW1WfLsrpzA7jRMN
 kdh9wBc6Y5POsGmjfWbEWVvz7iORLMI2rWX865ppVvsB5xJwB7
 oeg6lxTmkoPXtbs7VzkhAW/jtXb5qzqGCyCkijDQOMbjTnigkr
 G7ZVNUIH7dfA97cstx+Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 17:55:51 Maxime Ripard wrote:
> On Wed, May 21, 2014 at 05:23:41PM +0200, Arnd Bergmann wrote:
> > On Wednesday 21 May 2014 17:15:54 Maxime Ripard wrote:
> > > Changes from v7:
> > >   - select DMA_OF, since we're only relying on DT
> > > 
> > 
> > I missed the discussion about this issue, but it seems wrong to me.
> > DMA_OF is currently enabled if we have both DMAENGINE and OF turned on.
> > 
> > If OF is disabled but DMA_OF gets selected by DMA_SUN6I, what happens?
> 
> Is that even possible with a multiplatform-based platform?

It's not possible for ARCH_SUNXI or any other that depends on
ARCH_MULTIPLATFORM. I just noticed that you have 'depends on ARCH_SUNXI',
so the 'select DMA_OF' statement is just redundant, not wrong.

However, if the driver was 'depends on ARCH_SUNXI || COMPILE_TEST' as many
others are nowadays, it would be a bug.

	Arnd
