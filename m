Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3FXJUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:20:42 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35394 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3FXJUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:20:41 -0400
X-Spam-Score: -100.9
Message-ID: <51C80F32.4060500@asianux.com>
Date: Mon, 24 Jun 2013 17:19:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: arm64: kernel: add '#ifdef CONFIG_COMPAT' for aarch32_break_handler()
References: <51C53C06.7050205@asianux.com> <20130624084744.GA23779@mudshark.cambridge.arm.com>
In-Reply-To: <20130624084744.GA23779@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:47 PM, Will Deacon wrote:
> On Sat, Jun 22, 2013 at 06:54:14AM +0100, Chen Gang wrote:
>> > 
>> > If 'COMPAT' not defined, aarch32_break_handler() cannot pass compiling,
>> > so need add '#ifdef' for it just like the header file has done.
>> > 
>> > The related make:
>> > 
>> >   make ARCH=arm64 randconfig
>> >   make ARCH=arm64 menuconfig
>> >   make ARCH=arm64 V=1 EXTRA_CFLAGS=-W
>> > 
>> > The related error:
>> > 
>> >   arch/arm64/kernel/debug-monitors.c:249:5: error: redefinition of ‘aarch32_break_handler’
>> >   In file included from arch/arm64/kernel/debug-monitors.c:29:0:
>> >   /root/linux-next/arch/arm64/include/asm/debug-monitors.h:89:12: note: previous definition of ‘aarch32_break_handler’ was here
> Actually, can we just kill the static definition in debug-monitors.h
> instead? I don't see anything in the full-blown aardch32_break_handler that
> won't play nicely if !COMPAT.

It sounds good, I will send patch v2.

Thanks.
-- 
Chen Gang

Asianux Corporation
