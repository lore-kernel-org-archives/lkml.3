Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3ECPZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:25:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3ECPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:25:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH, RFC 01/22] can: move CONFIG_HAVE_CAN_FLEXCAN out of CAN_DEV
Date: Fri, 3 May 2013 17:24:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-can@vger.kernel.org
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-2-git-send-email-arnd@arndb.de> <5183892B.8020400@pengutronix.de>
In-Reply-To: <5183892B.8020400@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305031724.15584.arnd@arndb.de>
X-Provags-ID: V02:K0:OyWd5yjxeyFrXuBlmRtI7cQYWrIhheN4gLAttZKvsHo
 bw6ZzJ7km735EJKJ/jsHFJ0Guf14h2UUJc+kY7Cxe2D9IIOQOy
 NGNoA6GSQArGbZ+uF5AZ7XqtsaPNaa+TfwHqBk8BZvwjYEteiz
 9YnklQZT3ZWwJpQ/HWkacrPof6IbmGy8yhGYUPiBvnTaC1P9zk
 cLDjm9XrtnWa6jp65fKZBwE0qSDJgntK1eDeM9apk/uphgcRA8
 t1aqkuSXaP0wGf4LPfRoJ34Z2pD0QlChcgD4EbTJxdC7r7/VSI
 o3o3shHHdGUh9cqIKltVnQ9AoZWKupLZfHCzMTxfsb/2usa3Kp
 MJAn+KHmUTgmrAedheLE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 May 2013, Marc Kleine-Budde wrote:
> On 05/02/2013 05:16 PM, Arnd Bergmann wrote:
> > CONFIG_HAVE_CAN_FLEXCAN is a silect symbol that is meant to be selected
> > by platforms that support this driver, but that is not possible without
> > also selecting CAN_DEV, unless we move it out of the "if CAN_DEV"
> > section of the Kconfig file.
> > 
> > warning: (SOC_IMX28 && SOC_IMX25 && SOC_IMX35 &&
> >  IMX_HAVE_PLATFORM_FLEXCAN && SOC_IMX53 && SOC_IMX6Q) selects HAVE_CAN_FLEXCAN
> >  which has unmet direct dependencies (NET && CAN && CAN_DEV)
> 
> With the advent of multi platform kernels I like to get rid of
> HAVE_CAN_FLEXCAN completely.

Yes, good idea. Are there any other dependencies we need to add then?
I assume FLEXCAN needs to depend on HAS_IOMEM and OF at least, but
there might be more.

	Arnd
