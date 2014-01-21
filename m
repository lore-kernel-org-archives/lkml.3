Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaAUPNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:13:10 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42295 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754300AbaAUPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:13:08 -0500
Date: Tue, 21 Jan 2014 15:12:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] arm64: advertise availability of CRC and crypto
 instructions
Message-ID: <20140121151236.GE14830@arm.com>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140120173838.GD29971@arm.com>
 <alpine.LFD.2.11.1401201242480.1652@knanqh.ubzr>
 <CAKv+Gu8jqctGFsyccg6_VGkZ6ogf8BD_kq1rsRQrc+cw7pk+qA@mail.gmail.com>
 <alpine.LFD.2.11.1401201307300.1652@knanqh.ubzr>
 <CAKv+Gu8JEaVZDiOEegUeYfWbAMMH0ddgcWaTjFBpjXzoiKRoQg@mail.gmail.com>
 <alpine.LFD.2.11.1401201351120.1652@knanqh.ubzr>
 <CAKv+Gu8G+oSFWhVxbjPuj+Vn8Tk9E-g6og-fFjGdKsbmheHz-A@mail.gmail.com>
 <alpine.LFD.2.11.1401201427090.1652@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1401201427090.1652@knanqh.ubzr>
Thread-Topic: [PATCH v2 0/5] arm64: advertise availability of CRC and
 crypto instructions
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 07:42:36PM +0000, Nicolas Pitre wrote:
> On Mon, 20 Jan 2014, Ard Biesheuvel wrote:
> > Quoting Russell:
> > 
> > On 18 December 2013 12:42, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > The point is that they'll never appear on an ARMv7 implementation because
> > > they're not part of the ARMv7 architecture.  I see no point in needlessly
> > > polluting ARM32 with ARM64 stuff - in exactly the same way that you see
> > > no point in polluting ARM64 with ARM32 stuff.
> > >
> > > So, frankly, find a different way to this.  We don't need to needlessly
> > > waste HWCAP bits on ARM32.
> > 
> > So my idea was to use HWCAP2 bits instead ...
[...]
> You also decided to put the new crypto bits into HWCAP2.  I have no 
> actual objection with that either.
> 
> What makes me wonder is Catalin's affirmation about putting those new 
> bits into HWCAP2 making future extensions possible with old glibc 
> versions that don't have knowledge about HWCAP2.  That is what I don't 
> get the pertinence of.

I was looking for a justification for not touching HWCAP and instead
going directly to HWCAP2. Some user application compiled against an old
glibc could still access HWCAP via getauxval() but not HWCAP2. So that's
not for old glibc using new HWCAP bits itself.

A recent example is the HWCAP_EVSTRM which is ARMv7 only, some
application could implement some user space polling using WFE (I think
I've heard about smarter user locking in PostgreSQL). We may get other
ARMv7 ideas in the future or CPU implementations with features not
covered by the ARM ARM.

But if we decide to keep ARMv8 bits in HWCAP2, it's fine by me, I
already acked these patches. It's up to Russell whether he wants to take
them in this form or not.

-- 
Catalin
