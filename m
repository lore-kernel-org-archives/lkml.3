Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaENNVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:21:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58321 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaENNVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:21:33 -0400
Date: Wed, 14 May 2014 15:21:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>, "bp@suse.de" <bp@suse.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH 6/7] acpi, apei, ghes: Make unmapping functionality
 independent from architecture.
Message-ID: <20140514132121.GF5231@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-7-git-send-email-tomasz.nowicki@linaro.org>
 <20140513201118.GF8760@pd.tnic>
 <5373625B.4050401@linaro.org>
 <20140514123542.GG10145@arm.com>
 <20140514124505.GA19866@localhost>
 <20140514124834.GH10145@arm.com>
 <5373670D.5040603@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5373670D.5040603@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 02:52:29PM +0200, Tomasz Nowicki wrote:
> I am aiming ARM64 but ideally it should work for x86, arm64 and arm.

I guess you can call it local_flush_tlb_one() which calls
__flush_tlb_one() on x86 and flush_tlb_kernel_range() on arm*

A bunch of other arches have local_flush_tlb_one so going with that
naming might be on the right track :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
