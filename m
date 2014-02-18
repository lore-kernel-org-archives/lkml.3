Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaBROAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:00:16 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:64859 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaBROAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:00:14 -0500
MIME-Version: 1.0
In-Reply-To: <1392718107.15829.12.camel@artifact>
References: <1390773698.3450.12.camel@artifact> <CAE9FiQVD=oVHM5WJgSJ5cNpXZ1NYy9E_pcGWfjKnmD9OZoHHsw@mail.gmail.com>
 <1391643656.1067.1.camel@artifact> <CAE9FiQV8jutRhaBicL4kjqVYd07FzHmNoSN3NxdA2TYvOc_KUg@mail.gmail.com>
 <z9zi9m.n0zpxd.1hgeaud-qmf@mail.snewbury.org.uk> <i9nn22.n0zs79.1hgeaud-qmf@mail.snewbury.org.uk>
 <1392392764.3520.11.camel@devel-n900> <CAE9FiQV3H_nxH0gxcM0kW4uLm6b_qmHT9hRQUVY_4xPqjpvMtA@mail.gmail.com>
 <1392718107.15829.12.camel@artifact>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Feb 2014 06:59:53 -0700
Message-ID: <CAErSpo6cnT6JDh0rj_3TCjw8vkLbM0ztzES0Qh1R=wUCp0PfTw@mail.gmail.com>
Subject: Re: pci-3.14 resource alloc
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 3:08 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
> On Fri, 2014-02-14 at 11:11 -0800, Yinghai Lu wrote:
>> On Fri, Feb 14, 2014 at 7:46 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
>> >>
>> >> Oh, never mind! I didn't notice pref_bar has been renamed to
>> >> assign_pref_bars. It's working now! :)
>> >
>> > There's no pci bridge/bus hotplug though. Docking doesn't reveal the
>> > pci-e->pci bridge or the (radeon) devices on the other side.
>>
>> oh, no. could be other regression in linus tree or pci/next.
>>
>
> Sorry about taking a while to get back to you.
>
> Previously I needed the busn work to get it working, this was included
> in the resource-alloc branch.  It never worked on mainline, the bridge
> used to show up but never get scanned.  Now it's not showing up at all
> on hotplug.  It could be a dock driver regression.
>
>> Can you check if linus tree could reveal pci-e->pci bridge?
>>
> I'll give it a go.
>
>> or do you use iommu/dmar with the system?
>>
> No, the only unusual option is I use pci=nocrs since the bios is
> completely ignorant of support for 64bit BARs.

Hi Steven, this is a tangent, but can you collect the complete dmesg
log with "pci=nocrs" and let me know what happens when you *don't* use
"pci=nocrs" (a complete dmesg log there would be useful too, but I
don't know if you can boot without it)?  I think Linux *should* be
able to handle 64bit BARs even if the BIOS doesn't.

Please post these as a separate thread so we don't muddle this
conversation with Yinghai.

Bjorn
