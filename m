Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3J1GWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:22:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60597 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751737Ab3J1GWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:22:12 -0400
Message-ID: <526E0293.4080702@free-electrons.com>
Date: Mon, 28 Oct 2013 07:22:11 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Lan Tianyu <lantianyu1986@gmail.com>
CC: Len Brown <lenb@kernel.org>, rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: remove unused ACPI_PROCFS Kconfig param
References: <1382857012-2971-1-git-send-email-michael.opdenacker@free-electrons.com> <CAOLK0pxe0tsgo1+U8WT4-9cxTxS9MKaiGhLd2S-T-T7imPyd7A@mail.gmail.com>
In-Reply-To: <CAOLK0pxe0tsgo1+U8WT4-9cxTxS9MKaiGhLd2S-T-T7imPyd7A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lan,

Thank you very much for this review!

On 10/28/2013 07:13 AM, Lan Tianyu wrote:
> 2013/10/27 Michael Opdenacker <michael.opdenacker@free-electrons.com>:
>> This patch removes the ACPI_PROCFS parameter
>> (support for legacy /proc/acpi), which is defined
>> but no longer used anywhere in the makefiles and source code.
>>
> I think this should be not removed now. Since there are still interfaces
> under /proc/acpi (E.G, /proc/acpi/wakeup and /proc/acpi/lid/*).
>
> The origin commit which introduces the kconfig is to make some
> interfaces that have backup interfaces in the sysfs configurable before
> removing them actually.
>
> So we still need this kconfig when try to remove remaining /proc/acpi
> interfaces.

I agree that keeping this legacy interface would still be useful.
However, CONFIG_ACPI_PROCFS is no longer used anywhere, neither in
Makefiles nor in the source code. ACPI_PROCFS isn't event used in
Kconfig files as an intermediate dependency.

What I deduce from that is that even if you set CONFIG_ACPI_PROCFS=y in
the kernel configuration, this will have no impact at all.

That's why I proposed to  remove this Kconfig parameter.

Another option would be to fix the issue, and get CONFIG_ACPI_PROCFS to
be properly taken into account again.

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

