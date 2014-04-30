Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbaD3M3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:29:55 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41810 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227AbaD3M3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:29:53 -0400
Date: Wed, 30 Apr 2014 13:29:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "Ezequiel Garcia (ezequiel.garcia@free-electrons.com)" 
	<ezequiel.garcia@free-electrons.com>
Subject: Re: [RFC 07/47] mtd: nand: stm_nand_bch: initialise the BCH
 Controller
Message-ID: <20140430122946.GM29462@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-8-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5CB7@DBDE04.ent.ti.com>
 <20140430102244.GK29462@lee--X1>
 <20980858CB6D3A4BAE95CA194937D5E73EAC6A35@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAC6A35@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >+	/* Reset and disable boot-mode controller */
> >> >+	writel(BOOT_CFG_RESET, nandi->base + NANDBCH_BOOTBANK_CFG);
> >> >+	udelay(1);
> >> >+	writel(0x00000000, nandi->base + NANDBCH_BOOTBANK_CFG);
> >>
> >> Why using 'udelay' ?
> >> Isn't there any status register which tells you that controller is reset / initialized ?
> >> Or may be polling on NANDBCH_BOOTBANK_CFG may itself give you status.
> >
> >Documenation says:
> >
> >  "The soft reset bit has to be reset to ‘0’ to de-assert the soft
> >   reset. The soft reset bit is expected to be asserted for at least
> >   one clock cycle for proper reset"
> >
> That’s the hardware way of saying that 'enable the clock before applying reset'.
> Clock is required to propagate reset-logic to flip-flops in pipeline, which do not get direct reset.
> 
> However that apart. You may safely drop udelay(1) because this 'udelay' is at
> CPU side and won't guarantee anything about clocks at your controller side.
> But I leave it to you as this delay is pretty small.

I'd like to keep it in if it's all the same to you.  The original
author is pretty competent and I like to think that it's there for a
reason - and as you rightly say, the delay is pretty small.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
