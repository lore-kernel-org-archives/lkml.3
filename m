Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbaHZISE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:18:04 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:53622 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875AbaHZISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:18:00 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Miller <davem@davemloft.net>
Cc: dborkman@redhat.com, ffusco@redhat.com, tgraf@suug.ch,
        linux-kernel@vger.kernel.org, matthew@wil.cx, wli@holomorphy.com,
        akpm@linux-foundation.org, nyc@holomorphy.com
Subject: Re: [PATCH/RFC] hash: Let gcc decide how to multiply
Organization: D03
References: <1408968804-7295-1-git-send-email-linux@rasmusvillemoes.dk>
	<53FB32FD.4000603@redhat.com>
	<20140825.114754.1052522152538122040.davem@davemloft.net>
X-Hashcash: 1:20:140826:akpm@linux-foundation.org::59cN5Z3l9HxpZjJf:0000000000000000000000000000000000000RUu
X-Hashcash: 1:20:140826:tgraf@suug.ch::M2YeQg5KjiCYqQT3:00000Fcn
X-Hashcash: 1:20:140826:nyc@holomorphy.com::o0w34y6x1XiDaUO2:00000000000000000000000000000000000000000001RwZ
X-Hashcash: 1:20:140826:davem@davemloft.net::OjTUCAt8XQbAWyPg:0000000000000000000000000000000000000000002l50
X-Hashcash: 1:20:140826:linux-kernel@vger.kernel.org::pAnUedFMpjixSefH:0000000000000000000000000000000002qI6
X-Hashcash: 1:20:140826:ffusco@redhat.com::vFvEGd1sldol8Hxk:0000000000000000000000000000000000000000000023FU
X-Hashcash: 1:20:140826:wli@holomorphy.com::nWG951nqD+bCHRHn:00000000000000000000000000000000000000000002SVk
X-Hashcash: 1:20:140826:dborkman@redhat.com::6UXCd4Pmd/IO2L/I:0000000000000000000000000000000000000000003vp/
X-Hashcash: 1:20:140826:matthew@wil.cx::8Yh2t9fQB+Ztqqlp:0009PaN
Date: Tue, 26 Aug 2014 10:17:57 +0200
In-Reply-To: <20140825.114754.1052522152538122040.davem@davemloft.net> (David
	Miller's message of "Mon, 25 Aug 2014 11:47:54 -0700 (PDT)")
Message-ID: <87sikjhdfu.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Mon, 25 Aug 2014 14:58:37 +0200
>
>> On 08/25/2014 02:13 PM, Rasmus Villemoes wrote:
>>> A 9+ years old comment in hash_64 says that gcc can't optimize
>>> multiplication by GOLDEN_RATIO_PRIME_64. Well, compilers get smarter
>>> and CPUs get faster all the time, so it is perhaps about time to
>>> revisit that assumption.
>> 
>> Seems fine by me, but Cc'ing a couple of others (as those you have
>> Cc'ed haven't written that code :)). You might want to let your
>> changes go via Andrew's tree, too, perhaps ...
>
> You need to test the code generation for a cpu where the multiply
> instruction is more expensive than the shifts and adds.

Yes, I should, but I'm afraid I can't. I only have x86 hardware, and
even if I managed to set up some cross-compiler toolchain, I wouldn't
know what CPUs to target. So I was hoping someone else could test this
on appropriate platforms.

Thanks,
Rasmus
