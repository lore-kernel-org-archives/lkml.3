Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaFJGgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:36:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbaFJGgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:36:41 -0400
Message-ID: <5396A772.1060103@nod.at>
Date: Tue, 10 Jun 2014 08:36:34 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Out-of-bounds access in vread_hpet()
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI:
________________________________________________________________________________________________________
*** CID 1222081:  Out-of-bounds access  (ARRAY_VS_SINGLETON)
/arch/x86/vdso/vclock_gettime.c: 38 in vread_hpet()
32     #ifdef CONFIG_HPET_TIMER
33     extern u8 hpet_page
34     	__attribute__((visibility("hidden")));
35
36     static notrace cycle_t vread_hpet(void)
37     {
>>>     CID 1222081:  Out-of-bounds access  (ARRAY_VS_SINGLETON)
>>>     Using "&hpet_page" as an array.  This might corrupt or misinterpret adjacent memory locations.
38     	return *(const volatile u32 *)(&hpet_page + HPET_COUNTER);
39     }
40     #endif
41
42     #ifndef BUILD_VDSO32
43

Thanks,
//richard
