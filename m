Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3LTE0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:26:21 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:43236 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3LTE0T (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 19 Dec 2013 23:26:19 -0500
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20131219140918.GF3145@console-pimps.org>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-7-git-send-email-jlee@suse.com>
	 <20131219140918.GF3145@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Dec 2013 12:24:51 +0800
Message-ID: <1387513491.3539.4345.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-12-19 於 14:09 +0000，Matt Fleming 提到：
> On Thu, 19 Dec, at 03:51:47PM, Lee, Chun-Yi wrote:
> > UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
> > supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
> > 
> > This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
> > checks efi_enabled flag and efi-rtc driver should enabled.
> > 
> > Cc: Matt Fleming <matt.fleming@intel.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Matthew Garrett <matthew.garrett@nebula.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Jan Beulich <JBeulich@suse.com>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  arch/x86/platform/efi/efi.c |   17 +++++++++++++++++
> >  drivers/rtc/Kconfig         |    2 +-
> >  2 files changed, 18 insertions(+), 1 deletions(-)
> 
> This patch needs to be justified. Enabling the EFI runtime *Time
> functions just because they're available isn't good enough. We need to
> know why this patch improves things, what use case does it solve?
> 

The main purpose of enable efi-rtc driver is providing interface to
userspace access timezone field in EFI time services.

Currently have two BIOS interfaces provided the timezone field accessing
ability, ACPI TAD and EFI. I hope can enable them on x86_64 machines.

> The general attitude has been that we want to invoke the runtime
> services less, not more, due to the huge variety of runtime
> implementation bugs.
> 

I agreed, but userspace application should not be too often to access
RTC. Maybe only when system boot and set timezone.


Thanks a lot!
Joey Lee

