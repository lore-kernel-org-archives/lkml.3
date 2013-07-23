Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3GWHj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:39:56 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58265 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3GWHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:39:54 -0400
Date: Tue, 23 Jul 2013 09:39:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86, acpi: Fix wrong checking condition in
 acpi_register_lapic().
Message-ID: <20130723073950.GB13710@gmail.com>
References: <1374543541-4451-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374543541-4451-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tang Chen <tangchen@cn.fujitsu.com> wrote:

> We wanted to check if the acpi id is out of range. It should be:
> 	if (id >= (MAX_LOCAL_APIC)).

Does this have any practical impact, or can it wait until v3.12?

> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index d81a972..2a15ae7 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -199,7 +199,7 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
>  {
>  	unsigned int ver = 0;
>  
> -	if (id >= (MAX_LOCAL_APIC-1)) {
> +	if (id >= (MAX_LOCAL_APIC)) {

The parentheses are now superfluous.

Thanks,

	Ingo
