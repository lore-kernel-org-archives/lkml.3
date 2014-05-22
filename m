Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaEVLwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:52:22 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60786 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbaEVLwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:52:21 -0400
Date: Thu, 22 May 2014 12:52:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Christophe Kerello <christophe.kerello@st.com>,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 09/10] mtd: st_spi_fsm: Provide mask to obtain correct
 boot device pins
Message-ID: <20140522115216.GV6679@lee--X1>
References: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
 <1400757848-18075-10-git-send-email-lee.jones@linaro.org>
 <4231397.Nn7Rm5jh2O@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4231397.Nn7Rm5jh2O@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thursday 22 May 2014 12:24:07 Lee Jones wrote:
> > +       /* Mask to apply on boot_device_reg */
> > +       ret = of_property_read_u32(np, "st,boot-device-msk", &boot_device_msk);
> > +       if (ret)
> > +               goto boot_device_fail;
> > +
> > 
> 
> The binding defines this property as "optional", but the driver fails
> here if it's not provided. I suggest you add a default value here so you
> can deal with existing dts. The default should be documented in
> the binding as well.

The property is optional. It doesn't fail completely, merely skips the
boot device check and falls back to using SPI.  I can update the
documentation to this effect though, no problem.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
