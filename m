Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3JKFwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:52:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50735 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3JKFwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:52:18 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1381470205-7296-1-git-send-email-kys@microsoft.com>
References: <1381470205-7296-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] x86: hyperv: Fix a compilation warning
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 10 Oct 2013 22:52:04 -0700
To: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        olaf@aepfle.de
Message-ID: <1933a550-b9de-4ab2-b8bf-71f1d0f7bb96@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No real reason to do this.

"K. Y. Srinivasan" <kys@microsoft.com> wrote:
>The variable hv_lapic_frequency is only used when CONFIG_X86_LOCAL_APIC
>is defined. Make the necessary adjustment. 
>
>Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>---
> arch/x86/kernel/cpu/mshyperv.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/mshyperv.c
>b/arch/x86/kernel/cpu/mshyperv.c
>index 628ff50..d7ff7b8 100644
>--- a/arch/x86/kernel/cpu/mshyperv.c
>+++ b/arch/x86/kernel/cpu/mshyperv.c
>@@ -69,7 +69,6 @@ static struct clocksource hyperv_cs = {
> 
> static void __init ms_hyperv_init_platform(void)
> {
>-	u64	hv_lapic_frequency;
> 
> 	/*
> 	 * Extract the features and hints
>@@ -82,6 +81,7 @@ static void __init ms_hyperv_init_platform(void)
> 
> #ifdef CONFIG_X86_LOCAL_APIC
> 	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
>+		u64	hv_lapic_frequency;
> 		/*
> 		 * Get the APIC frequency.
> 		 */

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
