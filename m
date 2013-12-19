Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3LSOJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:09:41 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:54451 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab3LSOJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:09:39 -0500
Date: Thu, 19 Dec 2013 14:09:33 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Message-ID: <20131219140918.GF3145@console-pimps.org>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
 <1387439515-8926-7-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387439515-8926-7-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec, at 03:51:47PM, Lee, Chun-Yi wrote:
> UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
> supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
> 
> This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
> checks efi_enabled flag and efi-rtc driver should enabled.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Matthew Garrett <matthew.garrett@nebula.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/platform/efi/efi.c |   17 +++++++++++++++++
>  drivers/rtc/Kconfig         |    2 +-
>  2 files changed, 18 insertions(+), 1 deletions(-)

This patch needs to be justified. Enabling the EFI runtime *Time
functions just because they're available isn't good enough. We need to
know why this patch improves things, what use case does it solve?

The general attitude has been that we want to invoke the runtime
services less, not more, due to the huge variety of runtime
implementation bugs.

-- 
Matt Fleming, Intel Open Source Technology Center
