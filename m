Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaE0Nw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:52:59 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63258 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaE0Nw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:52:57 -0400
Message-ID: <538498A1.4030006@linaro.org>
Date: Tue, 27 May 2014 14:52:33 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Paul Bolle <pebolle@tiscali.nl>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v5 3/5] ARM: Conceal DEBUG_LL_UART_NONE from unsupported
 platforms
References: <1398355246-29571-1-git-send-email-daniel.thompson@linaro.org> <6624276.NBS809VbNB@wuerfel> <53848F7C.6020508@linaro.org> <8143025.UYbkItXldM@wuerfel>
In-Reply-To: <8143025.UYbkItXldM@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/14 14:37, Arnd Bergmann wrote:
>> I'm very happy to update my patch to follow this one. However since it
>> will render the corresponding debug-macro.S unreachable by KBuild I like
>> to nuke the file as well. Good idea?
> 
> No. See the description under config DEBUG_LL_UART_NONE:
> 
>                   Say Y here if your platform doesn't provide a UART option
>                   above. This relies on your platform choosing the right UART
>                   definition internally in order for low-level debugging to
>                   work.
> 
> The platforms I listed do have "a UART option above", e.g.
> 
>         config AT91_DEBUG_LL_DBGU0
>                 bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10 and 9rl"
>                 depends on HAVE_AT91_DBGU0
> 
> Most of the platforms that have an option like this put the file into
> include/debug, as is required for ARCH_MULTIPLATFORM. The ones that are
> not converted to ARCH_MULTIPLATFORM can have it in either place, see
> 
> config DEBUG_LL_INCLUDE
>         string
>         default "debug/8250.S" if DEBUG_LL_UART_8250 || DEBUG_UART_8250
>         default "debug/pl01x.S" if DEBUG_LL_UART_PL01X || DEBUG_UART_PL01X
> 	...
>         default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
>         default "mach/debug-macro.S"
> 
> Anything that is not explicitly listed under DEBUG_LL_INCLUDE will default
> to "mach/debug-macro.S", and the list does not (have to) match the choice
> statements in "Kernel low-level debugging port".

Ok. Thanks.

I'll refresh the patch shortly.


Daniel.

