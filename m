Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808Ab3GZUpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:45:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45814 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab3GZUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:45:32 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <51F2DBDD.8020709@zytor.com>
References: <rddfy5e894xuv6d47gu7hbuh.1374804892449@email.android.com>
	<51F1ED8F.40703@zytor.com>
	<20130726083314.4e2e333f@jbarnes-desktop>
	<20130726202418.GD21415@gmail.com>
	<51F2DBDD.8020709@zytor.com>
Date: Fri, 26 Jul 2013 22:45:31 +0200
X-Google-Sender-Auth: 40qGWYpTwgoGfYMKUZBV87b4UNQ
Message-ID: <CAKMK7uE_NCBG-2KqA0WTx1neDaiyvsNeF8CbGx16FArNde50RQ@mail.gmail.com>
Subject: Re: [Intel-gfx] Ugly patches for stolen reservation
From: Daniel Vetter <daniel@ffwll.ch>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/26/2013 01:24 PM, Ingo Molnar wrote:
>>
>> Am I being too pedantic in expecting that we still mark it
>> e820-reserved?
>>
>> This area really isnt an ordinary PCI resource such as a
>> BAR or an MMIO region. It's truly system RAM (which cannot
>> be moved/reallocated), used by graphics hardware, and the
>> firmware should have marked it reserved.
>>
>> (The end result should be the same in any case, so this is
>> a detail.)
>>
>
> I, too, would prefer to see it marked as reserved.

Yeah, current patches mark it as reserved. But since we don't want to
duplicate the detection code we want to switch to a more unique name
when mapping the e820 region into a iomem reservation so that when
i915.ko loads we can dig it out again.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
