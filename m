Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbaEEOxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:53:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58498 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbaEEOxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:53:33 -0400
Date: Mon, 5 May 2014 16:53:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/7] apei, mce: Call MCE-specific code only for X86
 architecture.
Message-ID: <20140505145331.GC4373@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-2-git-send-email-tomasz.nowicki@linaro.org>
 <20140505114445.GB4373@pd.tnic>
 <5367A181.3060300@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5367A181.3060300@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 04:34:41PM +0200, Tomasz Nowicki wrote:
> acpi_disable_cmcff as global value can switch off/on MC entries
> analysing via kernel args.

No, it switches off firmware first mode for correctable errors because
of buggy BIOSes - 9ad95879cd1b2 (what else...)

> This glob value resides in x86 ACPI code and has meaning only for MCE
> related mechanism,

Of course it doesn't!

> that is why I have moved it under hest_parse_cmc.

See APEI section in the ACPI spec "18.4 Firmware First Error Handling."

Regardless of what your version of APEI does, you actually shouldn't
need to touch acpi_disable_cmcff at all as it not arch-specific.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
