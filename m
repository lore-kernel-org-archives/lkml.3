Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbaFLKcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:32:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:41241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbaFLKcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:32:45 -0400
Date: Thu, 12 Jun 2014 12:32:38 +0200
From: Robert Richter <rric@kernel.org>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 2/5] acpi, apei, ghes: Introduce ACPI_APEI_NMI to make
 NMI error notification a GHES feature.
Message-ID: <20140612103238.GB22583@rric.localhost>
References: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org>
 <1401262770-25343-3-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401262770-25343-3-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.14 09:39:27, Tomasz Nowicki wrote:
> +config ACPI_APEI_NMI
> +	bool "NMI error notification support"
> +	default y
> +	depends on ACPI_APEI_GHES && X86
> +	help
> +	  Firmware first mode can use NMI notification mechanism to report errors
> +	  to operating system. This feature is currently supported by X86
> +	  architecture only.
> +

This selection is not necessary. I don't see why one should select
this at all. It's either there for an arch or not. Just use ARCH_HAS_
style and and hard select ARCH_HAS_ACPI_APEI_NMI for x86. There is no
need for the ACPI_APEI_GHES dependency then.

-Robert
