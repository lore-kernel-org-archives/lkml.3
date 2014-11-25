Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaKYRja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:39:30 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62426 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaKYRj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:39:28 -0500
Date: Tue, 25 Nov 2014 17:39:25 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: leif.lindholm@linaro.org, roy.franz@linaro.org,
        linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        msalter@redhat.com, dyoung@redhat.com, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, will.deacon@arm.com, catalin.marinas@arm.com,
        grant.likely@linaro.org, geoff.levand@linaro.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH v3 03/13] arm64: improve CONFIG_STRICT_DEVMEM handling
Message-ID: <20141125173925.GE3331@console-pimps.org>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
 <1416315432-8534-4-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416315432-8534-4-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov, at 01:57:02PM, Ard Biesheuvel wrote:
> Improve the handling of /dev/mem mappings under CONFIG_STRICT_DEVMEM by:
> - allowing read-only access to parts of System RAM that are not
>   considered memory by the kernel, this is mainly intended for exposing
>   UEFI Configuration tables to userland;
> - avoid using non-cached mappings for those parts of System RAM, as it
>   may result in mismatched attributes.

Is this really the best way to expose EFI config tables?

We already have parts in /sys/firmware/efi/ and in particular we expose
the runtime mappings there for kexec on x86.

Hooking this into the /dev/mem infrastructure just seems wrong to me.

-- 
Matt Fleming, Intel Open Source Technology Center
