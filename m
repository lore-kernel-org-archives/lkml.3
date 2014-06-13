Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaFMN3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:29:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:35338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaFMN3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:29:35 -0400
Date: Fri, 13 Jun 2014 15:29:24 +0200
From: Robert Richter <rric@kernel.org>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v3 4/5] apei, ghes, nmi: Factor out NMI arch-specific
 calls.
Message-ID: <20140613132924.GA27560@rric.localhost>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
 <1402657380-18539-5-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402657380-18539-5-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.14 13:02:59, Tomasz Nowicki wrote:
> Similar to MCE related patch, all NMI architectural calls are abstracted.
> Also, we are providing corresponding X86 functions' content.

We don't need to abstract nmi calls for archs that don't support
nmis. Just disable the code with #ifdefs depending on
ARCH_HAS_ACPI_APEI_NMI. Most changes in this patch, esp. all __weak
functions are obsolete then.

The remainings of this patch could probably merged with earlier
patches.

-Robert

> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  arch/x86/kernel/acpi/apei.c   |   25 +++++++++++++++++++++++++
>  drivers/acpi/apei/apei-base.c |   19 +++++++++++++++++++
>  drivers/acpi/apei/ghes.c      |   14 ++++++--------
>  include/acpi/apei.h           |    7 +++++++
>  4 files changed, 57 insertions(+), 8 deletions(-)
