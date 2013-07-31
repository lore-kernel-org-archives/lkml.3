Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab3GaJ5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:57:34 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44708 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3GaJ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:57:32 -0400
Message-ID: <51F8DF75.1030306@linux.vnet.ibm.com>
Date: Wed, 31 Jul 2013 15:27:09 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
References: <1374526866-6813-1-git-send-email-bp@alien8.de> <20130724171347.GB29756@naverao1-tp.watson.ibm.com> <1374686598.18818.18.camel@joe-AO722> <51F10AA8.2050901@linux.vnet.ibm.com> <CAErSpo5vLbsM5BXjrCVy1AKBxRRSH33TthyyK3O35Mghqw81nQ@mail.gmail.com> <20130729135812.GD6634@pd.tnic> <CAErSpo6fbMmicX95j_wYkJRnQeJEZ_jQSm76j9ZN4sHP0C2Yhg@mail.gmail.com> <20130729144046.GE6634@pd.tnic> <CAErSpo69wNc1h6PyJhFfhdFzz0GOiM=SCCfrm-WO5XDFTFzcHw@mail.gmail.com> <20130729152230.GG6634@pd.tnic>
In-Reply-To: <20130729152230.GG6634@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073109-9264-0000-0000-0000043CCBDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:52 PM, Borislav Petkov wrote:
> @@ -186,8 +186,8 @@ static int erst_exec_stall(struct apei_exec_context *ctx,
>
>   	if (ctx->value > FIRMWARE_MAX_STALL) {
>   		if (!in_nmi())
> -			pr_warning(FW_WARN ERST_PFX
> -			"Too long stall time for stall instruction: %llx.\n",
> +			pr_warn(FW_WARN
> +			"Too long stall time for stall instruction: 0x%llx.\n",

A minor nit: %#llx to stay consistent with the other changes later on.

>   				   ctx->value);
>   		stall_time = FIRMWARE_MAX_STALL;
>   	} else
> @@ -206,8 +206,8 @@ static int erst_exec_stall_while_true(struct apei_exec_context *ctx,
>
>   	if (ctx->var1 > FIRMWARE_MAX_STALL) {
>   		if (!in_nmi())
> -			pr_warning(FW_WARN ERST_PFX
> -		"Too long stall time for stall while true instruction: %llx.\n",
> +			pr_warn(FW_WARN
> +		"Too long stall time for stall while true instruction: 0x%llx.\n",

Ditto.


Thanks,
Naveen

