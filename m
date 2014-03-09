Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaCKNev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:34:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaCKNet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:34:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 4/7] of: configure the platform device dma_mask and dma_pfn_offset
Date: Sun, 9 Mar 2014 07:39:18 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com> <201403071702.41716.arnd@arndb.de> <CAL_JsqLu_16p-8FLjBYt7xQA2eAyiprPML2q5R3fnivZPrvPug@mail.gmail.com>
In-Reply-To: <CAL_JsqLu_16p-8FLjBYt7xQA2eAyiprPML2q5R3fnivZPrvPug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403090739.18351.arnd@arndb.de>
X-Provags-ID: V02:K0:DBdIBktTxnLAo36n6mWQ/EyjJzqD+mlZGLtvjnQPBY/
 /5PcT1NBlg3gnNaIEYitwTelxofDm6TDIE+b6GjJk42Po/OXkk
 TSHMctrkyegNC/VzB8MK2zFD7M+zcQzKRyuXd5recXKticm3RM
 C7yyar9qGYRR1kSo7d46NdCM80OcWccDbPAS+pQguy72nOFlvj
 3OcL6/5dx04OLMyOdj2kNJVspVx6YJlk5w6+Q1W0OTDNoXmAeV
 H/LECqXL4T7c+p0nGiCxcfCwgWrpwDEBGKmeOmNBea1r3HICv6
 ijiaZsYs58Zi31S3kd4nDX8nj4gmIPF+IVQ563UuuW2LGUePyh
 igu/E2ojpmlTsr5/szBLMiO5hMI1adxTgJ/jPbszS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 March 2014, Rob Herring wrote:
> On Fri, Mar 7, 2014 at 10:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> > a) Follow what we do for PCI devices: assume that we can do DMA_MASK(32)
> > on any device, and have drivers call dma_set_mask(DMA_MASK(64)) on devices
> > that would like to do more than that, or call e.g. dma_set_mask(DMA_MASK(28))
> > for devices that can do less than 32 bit, as given in the argument. This
> > approach would be most consistent with the way PCI works, but it doesn't
> > really work well for the case where the mask is less than 32-bit and the
> > device driver doesn't know that.
> >
> > b) Never have to call dma_set_mask() for platform devices and assume that the
> > platform code sets it up correctly. This would probably be the simpler
> > solution, and I can't think of any downsides at the moment.
> 
> I don't think we want this. In the case of setting up 64-bit masters,
> it is typically the device that knows if it can do 64-bit DMA either
> thru a capabilities register or compatible value. That device specific
> knowledge should really stay within the device's driver.

So you think we should still set a 64-bit mask in the "ranges" property
for devices that can only do 32-bit and let the driver figure it out?

I think this approach is much less useful for platform devices than it is
for PCI devices, where we don't explicitly describe the "ranges" for each
device. Are you thinking of off-chip or on-chip DMA masters here? If
on-chip, I don't think it's likely that we would end up with different
versions of the chip that have the same device on there but not the
same DMA capabilities.

	Arnd
