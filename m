Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaAMUb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:31:29 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37346 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaAMUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:31:25 -0500
MIME-Version: 1.0
In-Reply-To: <52D32962.5050908@redhat.com>
References: <1389380698-19361-1-git-send-email-prarit@redhat.com>
 <1389380698-19361-4-git-send-email-prarit@redhat.com> <alpine.DEB.2.02.1401111624170.20677@be1.lrz>
 <52D32962.5050908@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 13 Jan 2014 15:31:04 -0500
Message-ID: <CAHGf_=qWB81f8fdDdjaXXh1JoSDUsJmcEHwH+CEJ2E-5XWz6qA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, e820 disable ACPI Memory Hotplug if memory
 mapping is specified by user [v2]
To: Prarit Bhargava <prarit@redhat.com>
Cc: Bodo Eggert <7eggert@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linn Crosetto <linn@hp.com>, Pekka Enberg <penberg@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        dyoung@redhat.com, linux-acpi@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 6:46 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 01/11/2014 11:35 AM, 7eggert@gmx.de wrote:
>>
>>
>> On Fri, 10 Jan 2014, Prarit Bhargava wrote:
>>
>>> kdump uses memmap=exactmap and mem=X values to configure the memory
>>> mapping for the kdump kernel.  If memory is hotadded during the boot of
>>> the kdump kernel it is possible that the page tables for the new memory
>>> cause the kdump kernel to run out of memory.
>>>
>>> Since the user has specified a specific mapping ACPI Memory Hotplug should be
>>> disabled in this case.
>>
>> I'll ask just in case: Is it possible to want memory hotplug in spite of
>> using memmap=exactmap or mem=X?
>
> Good question -- I can't think of a case.  When a user specifies "memmap" or
> "mem" IMO they are asking for a very specific memory configuration.  Having
> extra memory added above what the user has specified seems to defeat the purpose
> of "memmap" and "mem".

May be yes, may be no.

They are often used for a wrokaround to avoid broken firmware issue.
If we have no way
to explicitly enable hotplug. We will lose a workaround.

Perhaps, there is no matter. Today, memory hotplug is only used on
high-end machine
and their firmware is carefully developped and don't have a serious
issue almostly. Though.
