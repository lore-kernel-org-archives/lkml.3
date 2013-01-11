Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3AKWSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:18:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53209 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab3AKWSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:18:15 -0500
Message-ID: <50F08F43.7080604@zytor.com>
Date: Fri, 11 Jan 2013 14:16:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Renninger <trenn@suse.de>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Subject: Re: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap
 case
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <201301111333.49238.trenn@suse.de> <CAE9FiQWPJdER++ZrkKx7cQpF0QvwBeghNjpFqK18pMNC0w20tw@mail.gmail.com> <1603289.LXteBtkifD@hammer82.arch.suse.de> <CAE9FiQU6RWH6cBKc9th3Eb2gCjcHfotbC1sYspQ7dU+cG=VMFA@mail.gmail.com> <50F070D8.2080109@zytor.com> <CAE9FiQWEan4Vq-pbp6sgMWVFHwWygQ4Hq2wRsPH166+7w7L2yg@mail.gmail.com>
In-Reply-To: <CAE9FiQWEan4Vq-pbp6sgMWVFHwWygQ4Hq2wRsPH166+7w7L2yg@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:09 PM, Yinghai Lu wrote:
> On Fri, Jan 11, 2013 at 12:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 01/11/2013 11:59 AM, Yinghai Lu wrote:
>>> On Fri, Jan 11, 2013 at 10:24 AM, Thomas Renninger <trenn@suse.de> wrote:
>>>>> We may need to keep exactmap intact.
>>>> Why?
>>>> Kexec/kdump should have been the only user?
>>>> If older/current kexec calls still add ACPI maps via memmap=X#Y,
>>>> they should already exist in the original e820 map and fall off or
>>>> get glued to one region if (wrongly) overlapping via sanitize_map.
>>>
>>> No, kexec/kdump is not the only user for memmap=exactmap.
>>>
>>
>> Who is using it then, since you seem to know?
> 
> http://forums.gentoo.org/viewtopic-t-487476-highlight-proliant.html
> 
> http://forums.fedoraforum.org/archive/index.php/t-225347.html
> 

Hm... both of those seem to be someone trying memmap=exactmap to hack
around a problem which really was elsewhere, with a different solution.

	-hpa

