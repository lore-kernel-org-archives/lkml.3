Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3KHRMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:12:37 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:55447 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab3KHRMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:12:36 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Nov 2013 12:12:36 EST
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 08 Nov 2013 17:02:57 +0000
In-Reply-To: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Thu, 7 Nov 2013 11:20:42 -0800")
Message-ID: <yw1xr4aqx1vi.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> +int __aeabi_idiv(int numerator, int denominator)
> +{
> +	if (static_key_false(&cpu_has_idiv)) {
> +		int ret;
> +
> +		asm volatile (
> +		".arch_extension idiv\n"
> +		"sdiv %0, %1, %2"
> +		: "=&r" (ret)

There is no need for the & in the output constraint.  Dropping it allows
using one of the source registers as destination which may sometimes be
beneficial.

> +		: "r" (numerator), "r" (denominator));
> +
> +		return ret;
> +	}
> +
> +	return ___aeabi_idiv(numerator, denominator);
> +}

-- 
Måns Rullgård
mans@mansr.com
