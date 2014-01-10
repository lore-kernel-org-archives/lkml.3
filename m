Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaAJONx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:13:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJONu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:13:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v5 2/9] mfd: omap-usb-host: Get clocks based on hardware revision
Date: Fri, 10 Jan 2014 15:13:39 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Roger Quadros <rogerq@ti.com>, bcousson@baylibre.com, tony@atomide.com,
        balbi@ti.com, sre@debian.org, mark.rutland@arm.com,
        m.paolino@virtualopensystems.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
References: <1389269303-30465-1-git-send-email-rogerq@ti.com> <1389269303-30465-3-git-send-email-rogerq@ti.com> <20140110102251.GH28141@lee--X1>
In-Reply-To: <20140110102251.GH28141@lee--X1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401101513.40470.arnd@arndb.de>
X-Provags-ID: V02:K0:AKy7eGeZY4/YaH9UregR9QHqTRu4mrmdE+VETURfMfc
 9+AWnXBjqUdfV7ACctRxWPY1wmRVMzIkQaY4L3NMYI34h+Au9V
 ua/GKuzR75tyslOXT4eg8+uCUvI6VkxAEUtO8UhnRZdSlHfNid
 fQfZfesSGlTe/K2ILmjJs27KNZCPZ6RNswkOW2Nrm7TcQRWNXC
 1WHTGDvCqd4vYzWkie5LeWOEOWhHGT16l0MF9GHctIzG44vhcU
 5C1NtP+9Zw9BahEXX5scn1f+5dHjInlJG8lRWivDkc83IivRrc
 yEe+f6EwG+tBjGDpuCtkQVmEVtvbC6N9PmhN5r4VwChsK76ms+
 +u/tVKQzBxKWQ/EIWNvM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 January 2014, Lee Jones wrote:
> >  
> > -     need_logic_fck = false;
> > +     /* Set all clocks as invalid to begin with */
> > +     omap->ehci_logic_fck = omap->init_60m_fclk = ERR_PTR(-EINVAL);
> > +     omap->utmi_p1_gfclk = omap->utmi_p2_gfclk = ERR_PTR(-EINVAL);
> > +     omap->xclk60mhsp1_ck = omap->xclk60mhsp2_ck = ERR_PTR(-EINVAL);
> 
> I don't think this is the correct error code.
> 
> -EINVAL means 'invalid parameter'.
> 
> You probably want -ENODEV or -ENOSYS ('function not implemented'
> probably isn't ideal either tbh, but you get the idea). Perhaps you
> can set them as NULL and check for IS_ERR_OR_NULL() instead?

I think ENODEV is ok here, I'd much prefer this over IS_ERR_OR_NULL().

	Arnd
