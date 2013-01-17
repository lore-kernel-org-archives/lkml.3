Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3AQTpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:45:30 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:23672
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754242Ab3AQTp3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:45:29 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
X-WSS-ID: 0MGSC7N-01-4ZW-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>,
        "jglisse@redhat.com" <jglisse@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux 3.8-rc3 reboot and shutdown
Thread-Topic: linux 3.8-rc3 reboot and shutdown
Thread-Index: AQHN9OVfBOBCoX5Y/Ea73ubzySE7LJhN7CZQ
Date: Thu, 17 Jan 2013 19:45:22 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DC2FB3A@sausexdag04.amd.com>
References: <CAKocOOMagCzn7fkkZJM+r5K--yXjZ40jCsHpwi97gCKo1keZ1A@mail.gmail.com>
In-Reply-To: <CAKocOOMagCzn7fkkZJM+r5K--yXjZ40jCsHpwi97gCKo1keZ1A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.12.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Thursday, January 17, 2013 2:03 PM
> To: jglisse@redhat.com; Deucher, Alexander
> Cc: linux-kernel@vger.kernel.org; Shuah Khan
> Subject: linux 3.8-rc3 reboot and shutdown
> 
> Alex,
> 
> I started seeing hang during shutdown and reboot on my laptop that has
> ATI radeon VGA.
> 
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
> ATI RV620 [Mobility Radeon HD 3400 Series] (prog-if 00 [VGA
> controller])
> 
> My bisect narrowed it to the following commit.

Should be fixed by this commit:
http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-3.8&id=19fc42ed9950d5fe17089c0a928121047c882092
Which should be finding its way upstream any day now.

Alex

> 
> shuah@lorien:~/lkml/linus_git_jan1$ git bisect good
> 71e3d1578c954cf29f1f4db1c8930d3574025eb0 is the first bad commit
> commit 71e3d1578c954cf29f1f4db1c8930d3574025eb0
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Thu Jan 3 12:20:35 2013 -0500
> 
>     drm/radeon: switch to a finer grained reset for r6xx/7xx
> 
>     No change in functionality as we currently set all the reset
>     flags.
> 
>     Reviewed-by: Jerome Glisse <jglisse@redhat.com>
>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> 
> :040000 040000 3fa285e9f06de6bb13d711eb87326e821036b0c6
> 9a9819551f3c7a893f2bfe7094ff0ca84e0e12d2 M	drivers
> 
> bisect log:
> 
> git bisect start '--' 'drivers/gpu/drm/radeon'
> # good: [d1c3ed669a2d452cacfb48c2d171a1f364dae2ed] Linux 3.8-rc2
> git bisect good d1c3ed669a2d452cacfb48c2d171a1f364dae2ed
> # bad: [9931faca02c604c22335f5a935a501bb2ace6e20] Linux 3.8-rc3
> git bisect bad 9931faca02c604c22335f5a935a501bb2ace6e20
> # bad: [71e3d1578c954cf29f1f4db1c8930d3574025eb0] drm/radeon: switch
> to a finer grained reset for r6xx/7xx
> git bisect bad 71e3d1578c954cf29f1f4db1c8930d3574025eb0
> # good: [eaaa6983ab2ccdf826c90838eb584211e0cadb76] drm/radeon: print
> dma status reg on lockup (v2)
> git bisect good eaaa6983ab2ccdf826c90838eb584211e0cadb76
> # good: [0a9069d34918659bc8a89e21e69e60b2b83291a3] drm/radeon:
> Properly handle DDC probe for DP bridges
> git bisect good 0a9069d34918659bc8a89e21e69e60b2b83291a3
> # good: [ec46c76d506e845d28d60d0a9f0e993d517030f5] drm/radeon: add
> GPU
> reset flags
> git bisect good ec46c76d506e845d28d60d0a9f0e993d517030f5
> 
> I don't have the dmesg from the bad boot. Will gather it shortly.
> 
> -- Shuah


