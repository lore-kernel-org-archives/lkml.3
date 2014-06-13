Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaFMOCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:02:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:37502 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaFMOCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:02:06 -0400
Date: Fri, 13 Jun 2014 16:01:55 +0200
From: Robert Richter <rric@kernel.org>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v3 2/5] acpi, apei, ghes: Introduce
 ARCH_HAS_ACPI_APEI_NMI to make NMI error notification a GHES feature.
Message-ID: <20140613140155.GE27560@rric.localhost>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
 <1402657380-18539-3-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402657380-18539-3-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.14 13:02:57, Tomasz Nowicki wrote:
> Currently APEI depends on x86 architecture. It is because of NMI hardware
> error notification of GHES which is currently supported by x86 only.
> However, many other APEI features can be still used perfectly by other
> architectures.
> 
> This commit adds ARCH_HAS_ACPI_APEI_NMI which will be used in next patches
> for NMI related code isolation in ghes.c file. Only NMI error notification
> feature depends on x86 so let it be hard selected for x86 arch.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  arch/x86/Kconfig          |    1 +
>  drivers/acpi/apei/Kconfig |    8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)

Apart from merging the patch with later ones this change looks fine to
me

> +config ARCH_HAS_ACPI_APEI_NMI
> +	bool
> +	help
> +	  Firmware first mode can use NMI notification mechanism to report errors
> +	  to operating system. This feature is currently supported by X86
> +	  architecture only.
> +

Maybe the help description could be removed, it is not used anywhere
in a dialog. At least the reference to x86 should be removed (if the
option is used for another arch the text will be wrong and need to be
changed again).

-Robert
