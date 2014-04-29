Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaD2Opm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:45:42 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34982 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757819AbaD2Opk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:45:40 -0400
Date: Tue, 29 Apr 2014 15:45:06 +0100
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
Subject: Re: [PATCH v4 3/7] arm64: Introduce a kernel configuration option
 for VA_BITS
Message-ID: <20140429144506.GK17007@arm.com>
References: <000301cf6367$ca12e150$5e38a3f0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301cf6367$ca12e150$5e38a3f0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:59:23AM +0100, Jungseok Lee wrote:
> +config ARM64_VA_BITS
> +	int "Virtual address space size"
> +	range 39 39 if ARM64_4K_PAGES && ARM64_3_LEVELS
> +	range 42 42 if ARM64_64K_PAGES && ARM64_2_LEVELS
> +	help
> +	  This feature is determined by a combination of page size and
> +	  level of translation tables.

OK, so you are doing the VA bits selection already. But see my other
email about setting only exposing this and hiding the number of levels
(though number of levels can be mentioned in the help).

-- 
Catalin
