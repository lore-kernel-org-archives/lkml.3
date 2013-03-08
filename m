Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab3CHOin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:38:43 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:19595 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3CHOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:38:42 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2013 09:38:41 EST
Date: Fri, 8 Mar 2013 09:28:39 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Black screen with nouveau in 3.8.x (regression)
Message-ID: <20130308142839.GA6185@elliptictech.com>
References: <20130307150618.GA31832@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307150618.GA31832@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-07 10:06 -0500, Nick Bowler wrote:
> I started a bisection... here's the first steps so far.  I will try to
> finish the procedure over the next couple days but I'm reporting this
> now in case someone needs me to get some other info.

I carried this on a bit further, but it seems that most of the remaining
commits bisect wants to test do not compile, so there is a huge number
of skipped commits.  Not exactly a lot of fun...

git bisect start 'drivers/gpu/drm'
# good: [3820288942d1c1524c3ee85cbf503fee1533cfc3] Linux 3.6.6
git bisect good 3820288942d1c1524c3ee85cbf503fee1533cfc3
# bad: [19b00d2dc9bedf0856e366cb7b9c7733ded659e4] Linux 3.8.2
git bisect bad 19b00d2dc9bedf0856e366cb7b9c7733ded659e4
# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
git bisect good a0d271cbfed1dd50278c6b06bead3d00ba0a88f9
# bad: [daed2dbb7ea4d179e472396ce46377fe758d5faf] drm/i915: use the CPU and PCH transcoders on lpt_pch_enable
git bisect bad daed2dbb7ea4d179e472396ce46377fe758d5faf
# good: [df86b5765a48d5f557489577652bd6df145b0e1b] drm/savage: re-add busmaster enable, regression fix
git bisect good df86b5765a48d5f557489577652bd6df145b0e1b
# bad: [39df01cd6ce9f6dd755ace0030e2bebe75da7727] Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
git bisect bad 39df01cd6ce9f6dd755ace0030e2bebe75da7727
# bad: [b9f10852fcb1f09369d931dcbfbaad89ad1da4ad] drm/nv98/crypt: fix fuc build with latest envyas
git bisect bad b9f10852fcb1f09369d931dcbfbaad89ad1da4ad
# bad: [b10f20d590aa040e4028c04a70a27b9ad6650ba8] drm/nvc0-/gr: remove reset-after-grctx-construction hack
git bisect bad b10f20d590aa040e4028c04a70a27b9ad6650ba8
# skip: [18c9b959fd8ea6f3602efbedad788f53e305e6f1] drm/nouveau/gpuobj: create wrapper functions for mapping gpuobj into vm/bar
git bisect skip 18c9b959fd8ea6f3602efbedad788f53e305e6f1
# skip: [092599da308bf56b96c849ecdd315b8a1a13ca52] drm/nv50/instmem: remove use of nouveau_gpuobj_new_fake()
git bisect skip 092599da308bf56b96c849ecdd315b8a1a13ca52
# skip: [4196faa8623264b79279a06fd186654c959f2767] drm/nouveau/i2c: port to subdev interfaces
git bisect skip 4196faa8623264b79279a06fd186654c959f2767
# skip: [9da226f698c01b268b9172050df4150f269a7613] drm/nvc0/fifo: handle bar1 control regs much like fifo/nve0
git bisect skip 9da226f698c01b268b9172050df4150f269a7613
# skip: [8aceb7de47ea2491abc1a577dc875b19e9947a54] drm/nouveau/clk: implement stub clock subdev
git bisect skip 8aceb7de47ea2491abc1a577dc875b19e9947a54
# skip: [70ee6f1cd6911098ddd4c11ee21b69dbe51fb3f9] drm/nv04-nv40/fifo: remove use of nouveau_gpuobj_new_fake()
git bisect skip 70ee6f1cd6911098ddd4c11ee21b69dbe51fb3f9
# skip: [f589be88caf32501a734e531180d5df5d6089ef3] drm/nouveau/pageflip: kick flip handling out of engsw and into fence
git bisect skip f589be88caf32501a734e531180d5df5d6089ef3
# skip: [73a60c0d218a292f8ef29d3467726ff26ed366fc] drm/nouveau/gpuobj: remove flags for vm-mappings
git bisect skip 73a60c0d218a292f8ef29d3467726ff26ed366fc
# skip: [70790f4f819875e8f390871fd15bbbf823f28e1b] drm/nouveau/clock: pull in the implementation from all over the place
git bisect skip 70790f4f819875e8f390871fd15bbbf823f28e1b
# skip: [5787640db6ae722aeadb394d480c7ca21b603e34] drm/nv04-nv40/instmem: remove use of nouveau_gpuobj_new_fake()
git bisect skip 5787640db6ae722aeadb394d480c7ca21b603e34
# skip: [cb75d97e9c77743ecfcc43375be135a55a4d9b25] drm/nouveau: implement devinit subdev, and new init table parser
git bisect skip cb75d97e9c77743ecfcc43375be135a55a4d9b25
# skip: [8a9b889e668a5bc2f4031015fe4893005c43403d] drm/nouveau: remove last use of nouveau_gpuobj_new_fake()
git bisect skip 8a9b889e668a5bc2f4031015fe4893005c43403d
# skip: [a73c5c526a8a39b2e61709c753d44be597c9a4c0] drm/nvc0-nve0/graph: rename dev to priv, no code changes
git bisect skip a73c5c526a8a39b2e61709c753d44be597c9a4c0
# good: [d6ba6d215a538a58f0f0026f0961b0b9125e8042] drm/nvc0/fence: restore pre-suspend fence buffer context on resume
git bisect good d6ba6d215a538a58f0f0026f0961b0b9125e8042
# skip: [7d9115dee978e8540734c456c925d71a37752b8d] drm/nouveau/mc: port to subdev interfaces
git bisect skip 7d9115dee978e8540734c456c925d71a37752b8d
# good: [3a92d37e4099054fe187b485a9d27c439c10eca7] drm/nouveau/gem: use bo.offset rather than mm_node.start
git bisect good 3a92d37e4099054fe187b485a9d27c439c10eca7
# skip: [5a5c7432bbbd2e318dff107b4ff960ab543a7cef] drm/nouveau/timer: port to subdev interfaces
git bisect skip 5a5c7432bbbd2e318dff107b4ff960ab543a7cef
# bad: [77145f1cbdf8d28b46ff8070ca749bad821e0774] drm/nouveau: port remainder of drm code, and rip out compat layer
git bisect bad 77145f1cbdf8d28b46ff8070ca749bad821e0774
# skip: [51a3d3425663698a79e8a9d01998a8a32ddee13b] drm/nouveau/backlight: remove dependence on nouveau_drv.h
git bisect skip 51a3d3425663698a79e8a9d01998a8a32ddee13b

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
