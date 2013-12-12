Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3LLPm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:42:27 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39225 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3LLPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:42:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAMe9rOr9L7OmdxGyzgiWuTTBXy4A+qUVa+3Mar+J_hE8H=rRZg@mail.gmail.com>
References: <CAMe9rOob2T+VWkZyHpaoBy6fUeTyAocpw4-cBpdrar2rtdAeew@mail.gmail.com>
	<20131210223615.GA10239@bubble.grove.modra.org>
	<CAMe9rOr9L7OmdxGyzgiWuTTBXy4A+qUVa+3Mar+J_hE8H=rRZg@mail.gmail.com>
Date: Thu, 12 Dec 2013 07:42:24 -0800
Message-ID: <CAMe9rOoJvfJ-R3zBwPEcpiULfCdRXPRpayZCaMmXf3k7014izw@mail.gmail.com>
Subject: Re: RFC: binutils PATCH: Set e_type to ET_EXEC for -pie -Ttext-segment=
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Binutils <binutils@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 2:47 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Tue, Dec 10, 2013 at 2:36 PM, Alan Modra <amodra@gmail.com> wrote:
>> On Mon, Dec 09, 2013 at 07:10:23PM -0800, H.J. Lu wrote:
>>> Linker sets e_type in ELF header to ET_DYN for -pie -Ttext-segment=0xXXX.
>>> When I added -Ttext-segment=0xXXX, one goal was to load
>>> small model executable above 4GB on Linux/x86-64, which
>>> was done with -pie -Ttext-segment=0xXXX.  But -pie sets
>>> e_type in ELF header to ET_DYN and kernel may ignore
>>> p_vaddr in ELF header to load ET_DYN binary at a random
>>> address.  This patch changes ld to set e_type in ELF header
>>> to ET_EXEC if the first PT_LOAD segment has non-zero
>>> p_vaddr.  If this is unacceptable as generic ELF change,
>>> I can make it specific to x86.
>>
>> Well, I suppose it's a hack to use ET_DYN for executables in the first
>> place, so one more hack in the linker hardly matters.  Why not just
>> patch the kernel though?  The kernel can look at the first PT_LOAD
>> header just as easily as the linker, and it's the kernel that is doing
>> the loading after all.
>>
>
> Kernel should have some freedom on where to load ET_DYN object.
> But when -Ttext-segment= is used, programmer expects the
> executable will be loaded at the specified address.  Setting
> ET_EXEC will guarantee that it will be loaded at that address.
>

I checked it in with 2 testcases.

-- 
H.J.
