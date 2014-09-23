Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaIWSXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:23:52 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52085 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaIWSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:23:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G support in big-endian model
Date: Tue, 23 Sep 2014 20:23:21 +0200
Message-ID: <4465641.JLAzuEs1O5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411492720444.3205@freescale.com>
References: <1411463719-7728-1-git-send-email-jingchang.lu@freescale.com> <45444544.Xl4NeUiTm0@wuerfel> <1411492720444.3205@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iXGgPD0gjw6LkB/+w4Ywao5+zNB7M1Iar8CKNm8jBty
 dBNuttWx8jDjUUAoPgo6vx7wpynkd4AhiIIwLMzMISWzW9EvK2
 +CH3lxaG6fus3/ePbp6MwxnEm8M9hNuhXDDLcA7E8OtRVd4YtH
 cysIlOZYFqebPf8bFWCg5aPHisfgujDrucRvCJinAqZylrBKr3
 Uti+4QvdxiysznMe8PWAXf1MYcZGX+60mFalHOHqMJeLIoN4d4
 h3tUUjSHcbhwH4NBadXea8QYzD1oF0BclrRzifUxXFqfHH+fgK
 4HnsNDWRLEUPXvjj9Bc1ouSKIQKRW2xkFOOXTIE101lEfVqjzC
 bC2CHW4Z584NLzIiBwpk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 17:18:43 Jingchang Lu wrote:
> I will reconsider this setting. BTW, why writel() can't be used
> for memory location since it's still mapped and registers space is
> also memory mapped? Thanks.

You cannot rely on an '__iomem' token to actually be a pointer, even
if that is currently the case on ARM.

On other architectures, the bits in the pointer can encode something
completely different, e.g. it may be the physical address on
architectures that have instructions to load/store on that directly,
and ioremap() in that case returns an identity mapping.

If you install sparse and build with 'make C=1', you will in fact
get a warning about the code when you assign a regular pointer to
an __iomem pointer or vice versa.

	Arnd
