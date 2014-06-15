Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbaFOKQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 06:16:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:56331 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaFOKQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 06:16:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stijn Volckaert <svolckae@elis.ugent.be>
Subject: Re: vdso feature requests from the Go people
Date: Sun, 15 Jun 2014 12:15:34 +0200
Message-ID: <lnjrop$mlp$1@ger.gmane.org>
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com> <539A8EA8.9080901@zytor.com> <CALCETrVya47r1j6YUHT4_=gb6Pb5qB4sGE5sfwmxievcjdTTUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-22-128-128.access.telenet.be
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
In-Reply-To: <CALCETrVya47r1j6YUHT4_=gb6Pb5qB4sGE5sfwmxievcjdTTUw@mail.gmail.com>
X-Antivirus: avast! (VPS 140615-0, 15/06/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski schreef op 13/06/2014 17:34:
> On Thu, Jun 12, 2014 at 10:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/12/2014 09:36 PM, Andy Lutomirski wrote:
>>>
>>> 1. Parsing the vDSO is a PITA.  What if we bundled the reference
>>> parser inside the vdso?  Concretely, we could have AT_VDSO_FINDENTRY
>>> point to a function like:
>>>
>>> void *vdso_find_entry(const char *name, const char *version)
>>>
>>> Then things like Go and maybe even musl (and klibc?) could just call
>>> that function.  And we'd never have to worry about maintaining
>>> compatibility with more and more weird vdso parsers.
>>>
>>> Implementing this could be as simple as shoving parse_vdso.c into the
>>> vdso, although vdso2c could help and allow a really simple in-vdso
>>> implementation.
>>>
>>
>> I'm not really sure how much of a win that is... you have to parse
>> *something*, and for the vast majority of all implementations there will
>> be a dynamic linker just sitting there, and that is what it *does*.
>
> I'm only aware of two implementations that work like that: glibc and
> musl.  AFAIK neither one even tries to use the vdso when statically
> linked.  IIRC, Bionic doesn't support the vdso at all, and Go has the
> present issue.

Glibc DOES use the VDSO even when it's statically linked. It uses the 
AT_SYSINFO_EHDR it gets from the kernel to find the VDSO and it will 
find any syms it needs dynamically.

--Stijn

