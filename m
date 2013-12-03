Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3LCMWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:22:42 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46921 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LCMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:22:40 -0500
MIME-Version: 1.0
In-Reply-To: <20131203113156.GB12031@lee--X1>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
	<1385727565-25794-15-git-send-email-lee.jones@linaro.org>
	<CACRpkdaWXBchz78Yby11VpveBDtn6FrmupS=cnNYhvHgFJsBUw@mail.gmail.com>
	<20131202110304.GB31626@lee--X1>
	<CACRpkdb8=RRsNRKe4Nbefu2BJ4xHakmNjxFC1gwLea=bAmOz-A@mail.gmail.com>
	<20131203113156.GB12031@lee--X1>
Date: Tue, 3 Dec 2013 13:22:37 +0100
Message-ID: <CACRpkdYdW+p4-sDNCr8L75YB+e6agiQfvfEX5V+wCs4iZUaKSQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/36] mtd: st_spi_fsm: Add device-tree binding documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 12:31 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 03 Dec 2013, Linus Walleij wrote:

>> So it can be in <linux/mfd/my-sysconfig-regs.h> as
>> a
>>
>> #define MY_SYSCON_V1_BOOT_DEV_REG 0x958
>> #define MY_SYSCON_V1_BOOT_DEV_SPI 0x1a
>>
>> The kernel should know which SoC is in use and
>> act apropriately right?
>
> And this have lots of machine_is() calls everywhere?

No need for Mr. Everywhere to know about the SoC.

There are other ways to achieve this. arch/arm/mach-foo
always knows which ASIC it is running on, and it can do
various things:

- Add device tree fragments/overlays (OK high-tech, but
  we're getting to this, inevitably)

- Selectively add AUXDATA, which is absolutely OK if
  we can do autoprobing of hardware IMO.

Yours,
Linus Walleij
