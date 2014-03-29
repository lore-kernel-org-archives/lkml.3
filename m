Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaC2BQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 21:16:51 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34131 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaC2BQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 21:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
Date: Fri, 28 Mar 2014 18:16:49 -0700
X-Google-Sender-Auth: 8iCiuDyJJTU1TFIhfD4TykzxWao
Message-ID: <CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com>
Subject: Re: BAR 14: can't assign mem (size 0x200000)
From: Yinghai Lu <yinghai@kernel.org>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 5:40 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> No issues with fresh boot, however after resume from suspend I see
> these messages -
>
> [11548.934625] pci_bus 0000:03: Allocating resources
> [11548.934645] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to
> [bus 03] add_size 1000
> [11548.934648] pci 0000:02:00.0: bridge window [mem
> 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
> [11548.934650] pci 0000:02:00.0: bridge window [mem
> 0x00100000-0x000fffff] to [bus 03] add_size 200000
> [11548.934653] pci 0000:02:00.0: res[14]=[mem 0x00100000-0x000fffff]
> get_res_add_size add_size 200000
> [11548.934655] pci 0000:02:00.0: res[15]=[mem 0x00100000-0x000fffff
> 64bit pref] get_res_add_size add_size 200000
> [11548.934656] pci 0000:02:00.0: res[13]=[io  0x1000-0x0fff]
> get_res_add_size add_size 1000
> [11548.934659] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
> [11548.934661] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 0x200000)
> [11548.934662] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
> [11548.934664] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
> [11548.934666] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 0x200000)
> [11548.934667] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
> [11548.934669] pci 0000:02:00.0: PCI bridge to [bus 03]
> [11548.934697] pci 0000:02:00.0: no hotplug settings from platform
> [11548.934698] pci 0000:02:00.0: using default PCI settings
>

>
> I am running Ubuntu daily mainline build from couple days ago - I
> think it should include the above commit.
>
> Let me know if more info is needed - I don't see any issues because of
> these but that may be because I am not using VTd for anything.

Can you send out whole boot log (include init booting and from resume) and
lspci -tv and lspci -vvxxxx ?

Thanks

Yinghai
