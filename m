Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaAQP0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:26:54 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60346 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaAQP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:26:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140117150725.GK16003@mudshark.cambridge.arm.com>
References: <1389950591-4212-1-git-send-email-ard.biesheuvel@linaro.org>
	<1389950591-4212-2-git-send-email-ard.biesheuvel@linaro.org>
	<20140117150725.GK16003@mudshark.cambridge.arm.com>
Date: Fri, 17 Jan 2014 16:26:50 +0100
Message-ID: <CAKv+Gu-dZZ4yzkDoHoHVRgW1KQ7H3PLy-OV731Es8BNmpkYqLQ@mail.gmail.com>
Subject: Re: [PATCH v2 resend 1/5] ARM: add support for AT_HWCAP2 ELF auxv entry
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 January 2014 16:07, Will Deacon <will.deacon@arm.com> wrote:
> Hi Ard,
>
> On Fri, Jan 17, 2014 at 09:23:07AM +0000, Ard Biesheuvel wrote:
>> This enables AT_HWCAP2 for ARM. The generic support for this
>> new ELF auxv entry was added in commit 2171364d1a9 (powerpc:
>> Add HWCAP2 aux entry)
>
> Does this require a corresponding change in libc so that the entry is
> actually used by the dynamic linker?
>

The auxv entry itself is already wired up [this includes getauxval()]

https://sourceware.org/git/?p=glibc.git;a=commit;h=1ae8bfe07c1a

The only thing that is lacking is a way to hook up ifunc relocation,
as the current prototype passes a single 32-bit quantity.
So either we change the prototype to (hwcap, hwcap2) or we need to
rely on getauxval() in ifunc selectors if they need to inspect hwcap2

-- 
Ard.
