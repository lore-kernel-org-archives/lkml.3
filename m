Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaC2Akl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:40:41 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47298 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaC2Akj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:40:39 -0400
MIME-Version: 1.0
Date: Fri, 28 Mar 2014 20:40:39 -0400
Message-ID: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
Subject: BAR 14: can't assign mem (size 0x200000)
From: Parag Warudkar <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, bhelgaas@google.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No issues with fresh boot, however after resume from suspend I see
these messages -

[11548.934625] pci_bus 0000:03: Allocating resources
[11548.934645] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to
[bus 03] add_size 1000
[11548.934648] pci 0000:02:00.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[11548.934650] pci 0000:02:00.0: bridge window [mem
0x00100000-0x000fffff] to [bus 03] add_size 200000
[11548.934653] pci 0000:02:00.0: res[14]=[mem 0x00100000-0x000fffff]
get_res_add_size add_size 200000
[11548.934655] pci 0000:02:00.0: res[15]=[mem 0x00100000-0x000fffff
64bit pref] get_res_add_size add_size 200000
[11548.934656] pci 0000:02:00.0: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[11548.934659] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
[11548.934661] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 0x200000)
[11548.934662] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
[11548.934664] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
[11548.934666] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 0x200000)
[11548.934667] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
[11548.934669] pci 0000:02:00.0: PCI bridge to [bus 03]
[11548.934697] pci 0000:02:00.0: no hotplug settings from platform
[11548.934698] pci 0000:02:00.0: using default PCI settings

The device in question is -

02:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8893
(rev 52) (prog-if 01 [Subtractive decode])
    Physical Slot: 5
    Flags: bus master, fast devsel, latency 0
    Bus: primary=02, secondary=03, subordinate=03, sec-latency=64
    Capabilities: [90] Power Management version 2
    Capabilities: [a0] Subsystem: Hewlett-Packard Company Device 1905

After resume the sec-latency is set to 128 instead of 64.

This seems to be VTd related - as if I disable VTd in BIOS the message
doesn't appear.

I saw an older commit which to me looked liked it fixed a similar issue -

PCI : Calculate right add_size

    commit a4ac9fea016fc5c09227eb479bd35e34978323a4 upstream.

    During debug of one SRIOV enabled hotplug device, we found found that
    add_size is not passed properly.

I am running Ubuntu daily mainline build from couple days ago - I
think it should include the above commit.

Let me know if more info is needed - I don't see any issues because of
these but that may be because I am not using VTd for anything.


Parag
