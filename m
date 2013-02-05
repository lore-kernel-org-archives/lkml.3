Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3BEIGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:06:53 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:58635 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3BEIGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:06:52 -0500
Date: Tue, 5 Feb 2013 09:06:37 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130205080637.GA22497@samfundet.no>
References: <20130127203954.GA22063@samfundet.no>
 <20130204001055.GV4503@ZenIV.linux.org.uk>
 <20130204003047.GW4503@ZenIV.linux.org.uk>
 <20130204013111.GX4503@ZenIV.linux.org.uk>
 <20130204030221.GY4503@ZenIV.linux.org.uk>
 <CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
 <20130204050550.GA4503@ZenIV.linux.org.uk>
 <CACiLriSguKWSfFfFGK99q1h+GLrfCSyh55xW8o67kOao3g5sWg@mail.gmail.com>
 <20130204153902.GC4503@ZenIV.linux.org.uk>
 <CACiLriQeYGGj5WZrf8H8z5N-AG1z_tDH7cXsd1J7ptpqYenPpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACiLriQeYGGj5WZrf8H8z5N-AG1z_tDH7cXsd1J7ptpqYenPpw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 04 Feb 2013 08:34:47 -0800 or thereabout, Håvard Skinnemoen wrote:
> On Mon, Feb 4, 2013 at 7:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Sun, Feb 03, 2013 at 09:35:39PM -0800, H?vard Skinnemoen wrote:
>>>
>>> > But yes, 32bit/32bit/64bit/32bit is another interesting case -
>>> > fanotify_mark is 32/32/64/32/32.  From what ABI says it would seem to
>>> > be r12/r11/r8:r9/r10/stack, but if I understand you correctly, we'll
>>> > end up wanting *two* arguments on stack...
>>>
>>> Yes, I think there may be a difference between the IAR and gcc ABI
>>> here. But I could be wrong.
>>
>> So it will use the gap in case of 32/32/64/32; the first two calls will
>> take index 0 and 1 (r12 and r11 resp.), the third will take 3 and 4
>> (r9:r8) and the fourth will take 2 (r10).
> 
> Oh, cool. I guess I am wrong then. Thanks a lot for taking the time to
> figure this out, and sorry I misled you.
> 
> If someone's got the toolchain installed (which I don't, sorry), it
> should be relatively straightforward to verify this by looking at the
> disassembly of a call to a function with a similar prototype.

The last avr32-linux toolchain I was able to build was 4.2.x, the openwrt
people got 4.3.x to build and produce a bootable system.

I have not tested the 4.4.x GCC port from Atmel.

-- 
mvh
Hans-Christian Egtvedt
