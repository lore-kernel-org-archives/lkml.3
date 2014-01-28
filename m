Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaA1JRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:17:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbaA1JRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:17:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
Date: Tue, 28 Jan 2014 10:16:53 +0100
Message-ID: <4697306.PPWWh8UGTE@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52E772DF.6000604@metafoo.de>
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org> <1390890471-14882-3-git-send-email-agross@codeaurora.org> <52E772DF.6000604@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6oZlzt0yFtsdPfIvgvvUwaWUI11hO5aGoP9BXt3dLDh
 PC9rX8R+F/rxeEe1JxSxYolmrUS3oveurjxwjqWzm45tZqkX9J
 +AY9JM3Qb+I3c1T/umIY556M4z24VZQBjdDi8p1iuQqHlL62wd
 qygl15Yq+lbkzifSfSDIrzpdsa6Tb1rKEkHWgfGQ0fGBYVMo3T
 mSagbhuN2tE3POFRbxssCrK9Y+Esqq9X0076NOl1Zf67RKj/6I
 zRvsLJoGUHINvOp7Tw+p98J+q3nsCTAXFZ/4VFXH19sAS8UJho
 gZtiD4oBGYDc1xfgjo3wUJSX5ZPqo8IEjfgIF0gOOTB/Jivqhu
 QHKAwekUGUJj1htEStps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 January 2014 10:05:35 Lars-Peter Clausen wrote:
> > +
> > +Clients must use the format described in the dma.txt file, using a three cell
> > +specifier for each channel.
> > +
> > +The three cells in order are:
> > +  1. A phandle pointing to the DMA controller
> > +  2. The channel number
> > +  3. Direction of the fixed unidirectional channel
> > +     0 - Memory to Device
> > +     1 - Device to Memory
> > +     2 - Device to Device
> > +
> 
> Why does the direction needs to be specified in specifier? I see two
> options, either the direction per is fixed in hardware. In that case the DMA
> controller node should describe which channel is which direction. Or the
> direction is not fixed in hardware and can be changed at runtime in which
> case it should be set on a per descriptor basis.

Normally the direction is implied by dmaengine_slave_config().
Note that neither the dma slave API nor the generic DT binding
can actually support device-to-device transfers, since this
normally implies using two dma-request lines rather than one.

There might be a case where the direction is required in order
to allocate a channel, because the engine has specialized channels
per direction, and might connect any of them to any dma request
line. This does not seem to be the case for "bam", because
the DMA specifier already contains a specific channel number, not
a request line or slave ID number.

	Arnd
