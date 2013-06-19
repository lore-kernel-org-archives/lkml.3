Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684Ab3FSM5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:57:32 -0400
Received: from smtp-out-224.synserver.de ([212.40.185.224]:1176 "EHLO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab3FSM53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:57:29 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17176
Message-ID: <51C1AAC4.3010605@metafoo.de>
Date: Wed, 19 Jun 2013 14:57:40 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: akhil.goyal@freescale.com
CC: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        pankaj.chauhan@freescale.com, "Getz, Robin" <robin.getz@analog.com>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Lars-Peter Clausen <lars-peter.clausen@analog.com>
Subject: Re: [PATCH 3/5] drivers/misc: rf/ad9361: AD9361 device driver for
 Radio phy
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com> <1371456566-4934-3-git-send-email-akhil.goyal@freescale.com> <1371456566-4934-4-git-send-email-akhil.goyal@freescale.com>
In-Reply-To: <1371456566-4934-4-git-send-email-akhil.goyal@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 10:09 AM, akhil.goyal@freescale.com wrote:
> From: Akhil Goyal <akhil.goyal@freescale.com>
> 
> AD9361 is a radio phy(RFIC) for radio networks. This phy
> can support LTE-FDD/LTE-TDD and WCDMA networks. The RFIC
> can convert the analog radio signals from air to digital
> IQ samples.
> 
> AD9361 is controlled via an SPI bus and all the register
> read/ write can be performed via SPI transactions.
> 
> Driver provides various operations for configuring and
> controlling the AD PHY. These can be controlled from the
> user space via the rfdev framework.
> 
> Driver also binds itself to one of AIC lane using RF framework.
> The combination of AIC lane and PHY connected to it works
> as one RF device.
> 
> Signed-off-by: Shaveta Leekha <shaveta@freescale.com>
> Signed-off-by: Pankaj Chauhan <pankaj.chauhan@freescale.com>
> Signed-off-by: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>
> Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>

Hi,

This is interesting. We at Analog Devices are currently also working on a
driver for this part. We are using the Linux Industrial IO (IIO) framework
though, since the AD9361 is more or less a multifunction device implementing
different functions already covered by the IIO framework, like ADCs, DACs,
clock chips and so on.

You seem to have made the kernel layer as thin as possible and provide a
IOCTL which allows userspace to directly modify the registers of the
hardware. So this sentence from the documentation "user space interface is
independent of component (vendor specific) drivers" is not exactly true. If
you write a userspace application it will still only work with one specific
RF-frontend. There is only a common interface on how to talk to the
frontend. Your documentation on this is also a bit sparse, e.g. there is no
explanation of the individual IOCTLs.

Since it is probably not such a good idea to have two different drivers for
the same device in different subsystems we should probably try to figure
something out that will work for us both.

I'd also be interested in learning more about how the userspace side looks like.

- Lars
