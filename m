Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaEVLrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:47:45 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51386 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaEVLrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:47:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Christophe Kerello <christophe.kerello@st.com>,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 09/10] mtd: st_spi_fsm: Provide mask to obtain correct boot device pins
Date: Thu, 22 May 2014 13:47:07 +0200
Message-ID: <4231397.Nn7Rm5jh2O@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400757848-18075-10-git-send-email-lee.jones@linaro.org>
References: <1400757848-18075-1-git-send-email-lee.jones@linaro.org> <1400757848-18075-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aqKdLyeEGQCuLn9aOR8eX1Sv2YLydVdOs4JecigpKTq
 oJTuG6Itft+47OS3UQQgqqCgH5lKjuMy7t/TEsVf8Ss6uzdVhK
 NZxKV5HhgaxyZpLjQYN54mH/uvfNzi/3Q2qTygbCC6z3n+jvLT
 yRKrwtRYpvg7RaKj/7cPSlXfEMpyE3vD+Xn13NZkdrGGToyIp5
 Aq6TipTqo1ZffP7ManUDC52Y6NuMcDvNzbDkUFSY5a7c4QL/n9
 +swjlEfvqW5vvpnC+SjFhbqbXLaXueVJgKp85XLUxzmLmVcVGh
 NjO6YbPqYah0AbS/wDWOrKmPb8dMhpizEQ/TXhY/JwdgozTjv7
 ENGYYVSzKWMuYe0+hxSo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014 12:24:07 Lee Jones wrote:
> +       /* Mask to apply on boot_device_reg */
> +       ret = of_property_read_u32(np, "st,boot-device-msk", &boot_device_msk);
> +       if (ret)
> +               goto boot_device_fail;
> +
> 

The binding defines this property as "optional", but the driver fails
here if it's not provided. I suggest you add a default value here so you
can deal with existing dts. The default should be documented in
the binding as well.

	Arnd
