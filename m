Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3DLXSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:18:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60948 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab3DLXSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:18:37 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51688803.8020401@sr71.net>
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com> <5166D18A.7090800@zytor.com> <20130412143104.GA4301@redhat.com> <5168208B.7050107@zytor.com> <51688803.8020401@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead of memmap= boot parameter
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 12 Apr 2013 16:17:17 -0700
To: Dave Hansen <dave@sr71.net>
CC: Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cliff Wickman <cpw@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <a13f7af9-9272-4407-9684-4d3693b5d3f2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes... That is one reason I think it is a real problem.


Dave Hansen <dave@sr71.net> wrote:

>On 04/12/2013 07:56 AM, H. Peter Anvin wrote:
>> On 04/12/2013 07:31 AM, Vivek Goyal wrote:
>>>> I also have to admit that I don't see the difference between
>/dev/mem
>>>> and /dev/oldmem, as the former allows access to memory ranges
>outside
>>>> the ones used by the current kernel, which is what the oldmem
>device
>>>> seems to be intended to od.
>
>It varies from arch to arch of course.
>
>But, /dev/mem has restrictions on it, like CONFIG_STRICT_DEVMEM or the
>ARCH_HAS_VALID_PHYS_ADDR_RANGE.  There's a lot of stuff that depends on
>it, *and* folks have tried to fix it up so that it's not _as_ blatant
>of
>a way to completely screw your system.
>
>/dev/mem also tries to be nice to arches that have restrictions like:
>
>>                         /*
>>                          * On ia64 if a page has been mapped
>somewhere as
>>                          * uncached, then it must also be accessed
>uncached
>>                          * by the kernel or data corruption may occur
>>                          */
>
>I think /dev/oldmem isn't so nice and could actually cause some real
>problems if used on ia64 where the cached/uncached accesses are mixed.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
