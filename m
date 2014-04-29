Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbaD2Ole (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:41:34 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23055 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757482AbaD2Olc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:41:32 -0400
Date: Tue, 29 Apr 2014 15:40:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "sungjinn.chung@samsung.com" <sungjinn.chung@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>
Subject: Re: [PATCH v4 2/7] arm64: Decouple page size from level of
 translation tables
Message-ID: <20140429144052.GJ17007@arm.com>
References: <000201cf6367$c8084440$5818ccc0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201cf6367$c8084440$5818ccc0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jungseok,

On Tue, Apr 29, 2014 at 05:59:20AM +0100, Jungseok Lee wrote:
> +choice
> +	prompt "Level of translation tables"
> +	default ARM64_3_LEVELS if ARM64_4K_PAGES
> +	default ARM64_2_LEVELS if ARM64_64K_PAGES
> +	help
> +	  Allows level of translation tables.
> +
> +config ARM64_2_LEVELS
> +	bool "2 level"
> +	depends on ARM64_64K_PAGES
> +	help
> +	  This feature enables 2 levels of translation tables.
> +
> +config ARM64_3_LEVELS
> +	bool "3 level"
> +	depends on ARM64_4K_PAGES
> +	help
> +	  This feature enables 3 levels of translation tables.
> +
> +endchoice

As I mentioned previously
(http://www.spinics.net/linux/lists/arm-kernel/msg319552.html), just
expose options for the VA space bits rather than the number of levels.
You can still keep the number of levels config options but not visible
in menuconfig (though I think you could also hide them in some header
and avoid config altogether). The VA bits config options can be:

VA_BITS_39 if 4K (3 levels)
VA_BITS_42 if 64K (2 levels)
VA_BITS_47 if 16K (3 levels)
VA_BITS_48 if 4K || 16K || 64K (4/4/3 levels depending on page size)

That's more meaningful to people configuring the kernel.

-- 
Catalin
