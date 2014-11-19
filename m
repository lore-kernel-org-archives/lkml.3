Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaKSOtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:49:32 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:62423 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaKSOta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:49:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@au1.ibm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from devices with an OF node
Date: Wed, 19 Nov 2014 15:49:13 +0100
Message-ID: <11269246.iBzpsM0jDI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqKk5UdFEa02wA+3N5BCM7coWAK=4jAr96Pw5eFh2n0ioQ@mail.gmail.com>
References: <1415342031.4925.27.camel@kernel.crashing.org> <3422452.OFUjscQXRB@wuerfel> <CAL_JsqKk5UdFEa02wA+3N5BCM7coWAK=4jAr96Pw5eFh2n0ioQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:z3+RtfWH90TPLpuOPn6e8GzoyYt6bCDF/yGD/U/V/+N
 qNQ8CfKB6HitoGHishQEIpGgIFWAzQ5D2G79vp8soLh3tyNJtm
 v3azjkgsSAbagrbBklscMAQKSqqVecJf5uoT9fUyRiPMulRSZh
 TIKz0Lg1z56+MPGLeJIFn2JRWdnynhHETav4eJ47px20NQ/aLi
 zHAQ44TOcIVV4XiMlp9ZEfK3lMJ0YThnzJoMlSuEAPNAwy871n
 KmCi8LXKd9Md6UPZZ+uxVPR/HikL44bAqX0WZFwLx5FLd/jo1s
 ulhrTlwKu2lBxnDzMj6N+VVPoqbbEjK/uAHk3H4FbCpwzYsPnF
 xfZKRhbVSfAE082cR80A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 08:45:58 Rob Herring wrote:
> > static inline struct device_node *dev_of_node(struct device *of_node)
> > {
> >         if (!IS_ENABLED(CONFIG_OF))
> >                 return NULL;
> >
> >         return dev->of_node;
> > }
> >
> > Adding the IS_ENABLED() in a lot of drivers isn't horrible, but we seem
> > to be doing it a lot.
> 
> I think you misread things. of_node is always present now, so it
> should always be NULL for !CONFIG_OF.
> 

No, I didn't misread it but I should have been clearer with the intention:
The idea is to tell the compiler that we know it will be NULL when CONFIG_OF
is unset, so it can optimize out all code that does

	struct device_node *dn = dev_of_node(dev);

	if (dn) {
		...
		/* complex code */
		...
	}

and we can avoid using an #ifdef or if(IS_ENABLED()) in the source to
compile out the DT-only sections of a driver.

	Arnd
