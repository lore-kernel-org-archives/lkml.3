Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3AQTDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:03:10 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:60256 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3AQTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:03:09 -0500
MIME-Version: 1.0
Date: Thu, 17 Jan 2013 12:03:07 -0700
Message-ID: <CAKocOOMagCzn7fkkZJM+r5K--yXjZ40jCsHpwi97gCKo1keZ1A@mail.gmail.com>
Subject: linux 3.8-rc3 reboot and shutdown
From: Shuah Khan <shuahkhan@gmail.com>
To: jglisse@redhat.com, alexander.deucher@amd.com
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

I started seeing hang during shutdown and reboot on my laptop that has
ATI radeon VGA.

01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
ATI RV620 [Mobility Radeon HD 3400 Series] (prog-if 00 [VGA
controller])

My bisect narrowed it to the following commit.

shuah@lorien:~/lkml/linus_git_jan1$ git bisect good
71e3d1578c954cf29f1f4db1c8930d3574025eb0 is the first bad commit
commit 71e3d1578c954cf29f1f4db1c8930d3574025eb0
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Thu Jan 3 12:20:35 2013 -0500

    drm/radeon: switch to a finer grained reset for r6xx/7xx

    No change in functionality as we currently set all the reset
    flags.

    Reviewed-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

:040000 040000 3fa285e9f06de6bb13d711eb87326e821036b0c6
9a9819551f3c7a893f2bfe7094ff0ca84e0e12d2 M	drivers

bisect log:

git bisect start '--' 'drivers/gpu/drm/radeon'
# good: [d1c3ed669a2d452cacfb48c2d171a1f364dae2ed] Linux 3.8-rc2
git bisect good d1c3ed669a2d452cacfb48c2d171a1f364dae2ed
# bad: [9931faca02c604c22335f5a935a501bb2ace6e20] Linux 3.8-rc3
git bisect bad 9931faca02c604c22335f5a935a501bb2ace6e20
# bad: [71e3d1578c954cf29f1f4db1c8930d3574025eb0] drm/radeon: switch
to a finer grained reset for r6xx/7xx
git bisect bad 71e3d1578c954cf29f1f4db1c8930d3574025eb0
# good: [eaaa6983ab2ccdf826c90838eb584211e0cadb76] drm/radeon: print
dma status reg on lockup (v2)
git bisect good eaaa6983ab2ccdf826c90838eb584211e0cadb76
# good: [0a9069d34918659bc8a89e21e69e60b2b83291a3] drm/radeon:
Properly handle DDC probe for DP bridges
git bisect good 0a9069d34918659bc8a89e21e69e60b2b83291a3
# good: [ec46c76d506e845d28d60d0a9f0e993d517030f5] drm/radeon: add GPU
reset flags
git bisect good ec46c76d506e845d28d60d0a9f0e993d517030f5

I don't have the dmesg from the bad boot. Will gather it shortly.

-- Shuah
