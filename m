Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaATQYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:24:37 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58809 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaATQYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:24:33 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-09-52dd4dbe2990
Message-id: <52DD4DB1.2050200@samsung.com>
Date: Mon, 20 Jan 2014 17:24:17 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Kevin Hilman <khilman@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power domain
 look-up
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
 <87r48a8t99.fsf@linaro.org>
In-reply-to: <87r48a8t99.fsf@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xa7r7fO8GGUydo2GxccZ6Vov5R86x
	WvS/Wchq0bx4PZvFuVcrGS16F1xls/h6eAWjxawpe5ksNj2+xmpxedccNovPvUcYLWac38dk
	cfsyr8XS6xeZLO6eOspmMWH6WhaLM6cvsVq07j3CbvHqYBuLxapdfxgdRDzWzFvD6NHS3MPm
	cbmvl8lj56y77B4rl39h81i85yWTx6ZVnWwed67tYfPYP3cNu8fmJfUeW662s3j0bVnF6LFi
	9Xd2j8+b5Dw2zg0N4I/isklJzcksSy3St0vgyriz4jZLwUPuiuabbUwNjMc4uxg5OSQETCT2
	7FvLAmGLSVy4t54NxBYSWMoo8eOHQBcjF5D9mVFi1ZXJYAleAS2JtmdTGLsYOThYBFQlHu6v
	BQmzCahJfG54BFYiKhAh8XfeekaIckGJH5Pvgc0XEfCS6Fg9gRVkJrPAWlaJE9N+sIMkhAXC
	JbbPms8MsWw+o8TC59PAujkFNCRuP5rKDGIzC1hLrJy0jRHClpfYvOYt8wRGgVlIlsxCUjYL
	SdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFx/GUH4+JjVocYBTgYlXh4OzzuBAmx
	JpYVV+YeYpTgYFYS4V3mdDdIiDclsbIqtSg/vqg0J7X4ECMTB6dUAyPLboGM22LNe7mfPpLg
	Tlu+2fIRIyPP1udHSrXXWbfrelyxX75SICnqxM1oPd+d/ZGeGw7xpcYuX37UM/69RAGvayOr
	wdl3wfF+BqXGESx7ej1PsrY0qScvuqEhtOTLOu5z3t3zfGaFpGx+MCufe6pfE+P/FRYXgy76
	rchinr1licvPGW+TXyixFGckGmoxFxUnAgDWxjIbwQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On 14.01.2014 16:42, Kevin Hilman wrote:
> Tomasz Figa <tomasz.figa@gmail.com> writes:
>
>> This patch introduces generic code to perform power domain look-up using
>> device tree and automatically bind devices to their power domains.
>> Generic device tree binding is introduced to specify power domains of
>> devices in their device tree nodes.
>>
>> Backwards compatibility with legacy Samsung-specific power domain
>> bindings is provided, but for now the new code is not compiled when
>> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
>> will change as soon as Exynos power domain code gets converted to use
>> the generic framework in further patch.
>>
>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>
> I haven't read through this in detail yet, but wanted to make sure that
> the DT representation can handle nested power domains.  At least
> SH-mobile has a hierarchy of power domains and the genpd code can handle
> that, so wanted to make sure that the DT representation can handle it as
> well.

The representation of power domains themselves as implied by this patch 
is fully platform-specific. The only generic part is the 
#power-domain-cells property, which defines the number of cells needed 
to identify the power domain of given provider. You are free to have any 
platform-specific properties (or even generic ones, added on top of this 
patch) to let you specify the hierarchy in DT.

Best regards,
Tomasz
