Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3F2S1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 14:27:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60621 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab3F2S1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 14:27:39 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130629175743.GA382@mtj.dyndns.org>
References: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com> <20130629152959.GB31339@mtj.dyndns.org> <20130629172123.GA3353@n2100.arm.linux.org.uk> <20130629175743.GA382@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 29 Jun 2013 11:23:43 -0700
To: Tejun Heo <tj@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, linux-arch@vger.kernel.org
Message-ID: <23a25575-484a-4013-b555-f7f79534589d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 makes sense to me.

Tejun Heo <tj@kernel.org> wrote:

>( Expanding cc list, original thread is at
>  http://thread.gmane.org/gmane.linux.kernel/1518046 )
>
>Hello,
>
>On Sat, Jun 29, 2013 at 06:21:24PM +0100, Russell King - ARM Linux
>wrote:
>> Unfortunately, that has not been true on ARM - it's very common for
>> there to be an offset on physical memory, sometimes of the order of
>> 3GB or more.  This is because on reset, ARMs start executing the code
>> at physical address zero, which therefore can't be RAM - and there's
>> a desire to avoid complex switching games in hardware to temporarily
>> map ROM there instead of RAM.
>> 
>> On these SoCs which Santosh is working on, the main physical memory
>> mapping is above 4GB, with just a small alias below 4GB to allow the
>> system to boot without the MMU being on, as they may have more than
>> 4GB of RAM.  As I understand it, the small alias below 4GB is not
>> suitable for use as a "lowmem" mapping.
>
>Ah, okay, so the @limit which is in physical address can be over 4GB
>even for lowmem mappings and alloc_bootmem takes them in ulongs,
>urghhh....
>
>Given that still about half of the archs aren't using memblock yet, I
>think there are three options.
>
>1. Converting all bootmem interface to use physaddr_t.  But that's
>   what memblock is.
>
>2. Introducing new interface.  Easier right now but the danger there
>   is that it might end up duplicating most of alloc_bootmem()
>   interface anyway and we'll have yet another variant of early mem
>   allocator to enjoy.
>
>3. Make all generic code use memblock interface instead of bootmem and
>   implement memblock wrapper on archs which don't use memblock yet.
>   We'll probably need to sort out different combinations of
>   HAVE_MEMBLOCK and NO_BOOTMEM.  If this is doable, it probably is
>   the most future proof way.  While it adds new memblock interface
>   built on top of bootmem, it would also allow removing the bootmem
>   interface built on top of memblock - ie. nobootmem.c, which
>   probably is what we should have done from the beginning.
>
>What do you guys think?
>
>Thanks.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
