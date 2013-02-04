Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3BDQev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:34:51 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:32914 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3BDQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:34:49 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:2602:baac:6fff:fe8c:a1a5]
In-Reply-To: <20130204153902.GC4503@ZenIV.linux.org.uk>
References: <20130127195714.GA11224@samfundet.no>
	<20130127203009.GG4503@ZenIV.linux.org.uk>
	<20130127203954.GA22063@samfundet.no>
	<20130204001055.GV4503@ZenIV.linux.org.uk>
	<20130204003047.GW4503@ZenIV.linux.org.uk>
	<20130204013111.GX4503@ZenIV.linux.org.uk>
	<20130204030221.GY4503@ZenIV.linux.org.uk>
	<CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
	<20130204050550.GA4503@ZenIV.linux.org.uk>
	<CACiLriSguKWSfFfFGK99q1h+GLrfCSyh55xW8o67kOao3g5sWg@mail.gmail.com>
	<20130204153902.GC4503@ZenIV.linux.org.uk>
Date: Mon, 4 Feb 2013 08:34:47 -0800
X-Google-Sender-Auth: jwpE5AVvUI6ykyfD8QRSCEAumkU
Message-ID: <CACiLriQeYGGj5WZrf8H8z5N-AG1z_tDH7cXsd1J7ptpqYenPpw@mail.gmail.com>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 7:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Feb 03, 2013 at 09:35:39PM -0800, H?vard Skinnemoen wrote:
>>
>> > But yes, 32bit/32bit/64bit/32bit is another interesting case -
>> > fanotify_mark is 32/32/64/32/32.  From what ABI says it would seem to
>> > be r12/r11/r8:r9/r10/stack, but if I understand you correctly, we'll
>> > end up wanting *two* arguments on stack...
>>
>> Yes, I think there may be a difference between the IAR and gcc ABI
>> here. But I could be wrong.
>
> So it will use the gap in case of 32/32/64/32; the first two calls will
> take index 0 and 1 (r12 and r11 resp.), the third will take 3 and 4
> (r9:r8) and the fourth will take 2 (r10).

Oh, cool. I guess I am wrong then. Thanks a lot for taking the time to
figure this out, and sorry I misled you.

If someone's got the toolchain installed (which I don't, sorry), it
should be relatively straightforward to verify this by looking at the
disassembly of a call to a function with a similar prototype.

Havard
