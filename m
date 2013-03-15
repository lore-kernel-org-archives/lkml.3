Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3COJnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:43:09 -0400
Received: from mx02.infracom.it ([62.196.48.10]:18891 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3COJnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:43:04 -0400
Message-ID: <5142ED1A.1040500@infracom.it>
Date: Fri, 15 Mar 2013 10:42:50 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot
 on HP 6730B - bisected
References: <513D8F3A.8030308@gmail.com> <51418863.8000902@infracom.it> <1453029.sQIX9a1hrM@vostro.rjw.lan>
In-Reply-To: <1453029.sQIX9a1hrM@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/03/2013 18:27, Rafael J. Wysocki ha scritto:
> On Thursday, March 14, 2013 09:20:51 AM Roberto Oppedisano wrote:
> As Toshi said, this particular commit doesn't make any functional 
> changes. Can you please verify if the immediately preceding commit 
> 6af9a803f4d2e4137d9f74a8fc9af4857fbda001 works for you? Rafael 

I have checked out this commit and it is NOT working.

BTW I did find the same commit in my bisection log, and probably
it was a false negative (I tried a couple of boot for each working kernel
during bisectrion, probably it was not not enough).
I'm going to replay the bisection today; will report back ASAP, to see
if it ends in something which makes sense to you.

For reference the current bisect log.

it bisect start
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
git bisect good 19f949f52599ba7c3f67a5897ac6be14bfcb1200
# bad: [6dbe51c251a327e012439c4772097a13df43c5b8] Linux 3.9-rc1
git bisect bad 6dbe51c251a327e012439c4772097a13df43c5b8
# bad: [b274776c54c320763bc12eb035c0e244f76ccb43] Merge tag 'cleanup' of 
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad b274776c54c320763bc12eb035c0e244f76ccb43
# bad: [a0b1c42951dd06ec83cc1bc2c9788131d9fefcd8] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect bad a0b1c42951dd06ec83cc1bc2c9788131d9fefcd8
# good: [98d5fac2330779e6eea6431a90b44c7476260dcc] Merge branch 'master' 
of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next 
into for-davem
git bisect good 98d5fac2330779e6eea6431a90b44c7476260dcc
# good: [8a3a11f91def34424b1995cb54ccd658efde8568] Merge tag 
'pinctrl-for-v3.9' of 
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good 8a3a11f91def34424b1995cb54ccd658efde8568
# bad: [10baf04e95fbf7eb6089410220a547211dd2ffa7] Merge branch 'release' 
of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux
git bisect bad 10baf04e95fbf7eb6089410220a547211dd2ffa7
# bad: [3757b94802fb65d8f696597a74053cf21738da0b] ACPI / hotplug: Fix 
concurrency issues and memory leaks
git bisect bad 3757b94802fb65d8f696597a74053cf21738da0b
# bad: [64e94e7e0ffb20ee11a596aa04fcdeefb33e000d] Merge branch 
'acpi-scan' into acpi-cleanup
git bisect bad 64e94e7e0ffb20ee11a596aa04fcdeefb33e000d
# bad: [993cbe595dda731471a07f4f65575fadedc570dc] ACPI / PM: Take order 
attribute of wakeup power resources into account
git bisect bad 993cbe595dda731471a07f4f65575fadedc570dc
# good: [e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e] ACPI: Remove unused 
struct acpi_pci_root.id member
git bisect good e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e
# bad: [05404d8f7b5c831e1a2c24bb782f0fe8ea02354c] ACPI / scan: Add 
second pass to acpi_bus_trim()
git bisect bad 05404d8f7b5c831e1a2c24bb782f0fe8ea02354c
# good: [6af9a803f4d2e4137d9f74a8fc9af4857fbda001] ACPI: Remove the ops 
field from struct acpi_device <---- BAD
git bisect good 6af9a803f4d2e4137d9f74a8fc9af4857fbda001
# bad: [ae281795ec92d35dd1631401829124acab965b1f] ACPI / scan: Drop the 
second argument of acpi_bus_trim()
git bisect bad ae281795ec92d35dd1631401829124acab965b1f
# bad: [b17b537ac1429a609addb55bf985f5ebfcf4ae7b] ACPI / scan: Drop the 
second argument of acpi_device_unregister()
git bisect bad b17b537ac1429a609addb55bf985f5ebfcf4ae7b

Kind regards
R
