Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaJTN4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:56:37 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:63604 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaJTN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141002150804.GP20170@rric.localhost>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
	<CAL1qeaGCeRyeKLo70E264bZcamOfBKoN9Y8_NDCjV5j4DoOw1Q@mail.gmail.com>
	<20140919123056.GC20170@rric.localhost>
	<20140919140856.GG2295@e104818-lin.cambridge.arm.com>
	<20140923112619.GG20170@rric.localhost>
	<20141002150804.GP20170@rric.localhost>
Date: Mon, 20 Oct 2014 19:26:32 +0530
Message-ID: <CAM4voakQnY1JMnjrXfTSNTyzA6_f6jtUgJZXXz2N0YRjq3kXRg@mail.gmail.com>
Subject: Re: [GIT PULL] dts, kbuild: Implement support for dtb vendor subdirs
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Robert Richter <rric@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Bresticker <abrestic@google.com>, Michal Marek <mmarek@suse.cz>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Thu, Oct 2, 2014 at 8:38 PM, Robert Richter <rric@kernel.org> wrote:
> On 23.09.14 13:26:19, Robert Richter wrote:
>> On 19.09.14 15:08:56, Catalin Marinas wrote:
>> > On Fri, Sep 19, 2014 at 01:30:56PM +0100, Robert Richter wrote:
>> > > On 16.09.14 20:49:18, Andrew Bresticker wrote:
>> > > > > Robert Richter (6):
>> > > > >   dts, arm64: Add dtbs_install make target
>> > > > >   dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
>> > > > >   dts, arm/arm64: Remove dtbs build rules in sub-makes
>> > > > >   dts, kbuild: Implement support for dtb vendor subdirs
>> > > > >   dts, arm64: Move dts files to vendor subdirs
>> > > > >   dts, arm: Remove $(MACHINE) variable from dtbs make recipes
>> > > >
>> > > > I've tested this for arm64 and by adding a vendor sub-directory
>> > > > locally for arm.  This series is also the base for my MIPS DT vendor
>> > > > sub-directory series
>> > > > (http://www.linux-mips.org/archives/linux-mips/2014-09/msg00217.html).
>> > > > So, for the entire series,
>> > > >
>> > > > Tested-by: Andrew Bresticker <abrestic@chromium.org>
>> > >
>> > > Andrew, thanks for testing and great this also works on mips.
>> > >
>> > > Anyone willing to take the patches for 3.18? Are any further acks
>> > > needed?
>> >
>> > For the arm64 bits in this series:
>> >
>> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> >
>> > I think the patches can be merged via arm-soc.
>>
>> Olof,
>>
>> please apply the patches.
>
> Olof, Arnd,
>
> you may want to pull from here alternatively.

I have been using your patchset as the base for my new arm64 SoC
support (http://www.spinics.net/lists/linux-samsung-soc/msg37047.html).
Are you planning to rebase and send this again as some of the patches
did not apply cleanly for me on linux-next.

Regards,
Abhilash
>
> Thanks,
>
> -Robert
>
>
> The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:
>
>   Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git tags/dts-subdirs-for-arm-soc-v3.18
>
> for you to fetch changes up to 87bdf4d8625e50d99b56aa2590a2261049a5fd48:
>
>   dts, arm: Remove $(MACHINE) variable from dtbs make recipes (2014-09-03 21:46:49 +0200)
>
> ----------------------------------------------------------------
> dts, kbuild: Implement support for dtb vendor subdirs
>
> ----------------------------------------------------------------
> Robert Richter (6):
>       dts, arm64: Add dtbs_install make target
>       dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
>       dts, arm/arm64: Remove dtbs build rules in sub-makes
>       dts, kbuild: Implement support for dtb vendor subdirs
>       dts, arm64: Move dts files to vendor subdirs
>       dts, arm: Remove $(MACHINE) variable from dtbs make recipes
>
>  arch/arm/Makefile                                  |  8 +++-
>  arch/arm/boot/dts/Makefile                         | 12 +-----
>  arch/arm64/Makefile                                | 10 ++++-
>  arch/arm64/boot/dts/Makefile                       | 13 +++---
>  arch/arm64/boot/dts/apm/Makefile                   |  5 +++
>  arch/arm64/boot/dts/{ => apm}/apm-mustang.dts      |  0
>  arch/arm64/boot/dts/{ => apm}/apm-storm.dtsi       |  0
>  arch/arm64/boot/dts/arm/Makefile                   |  6 +++
>  arch/arm64/boot/dts/{ => arm}/foundation-v8.dts    |  0
>  arch/arm64/boot/dts/{ => arm}/rtsm_ve-aemv8a.dts   |  0
>  .../boot/dts/{ => arm}/rtsm_ve-motherboard.dtsi    |  0
>  scripts/Kbuild.include                             |  6 +++
>  scripts/Makefile.dtbinst                           | 50 ++++++++++++++++++++++
>  scripts/Makefile.lib                               | 12 ------
>  14 files changed, 88 insertions(+), 34 deletions(-)
>  create mode 100644 arch/arm64/boot/dts/apm/Makefile
>  rename arch/arm64/boot/dts/{ => apm}/apm-mustang.dts (100%)
>  rename arch/arm64/boot/dts/{ => apm}/apm-storm.dtsi (100%)
>  create mode 100644 arch/arm64/boot/dts/arm/Makefile
>  rename arch/arm64/boot/dts/{ => arm}/foundation-v8.dts (100%)
>  rename arch/arm64/boot/dts/{ => arm}/rtsm_ve-aemv8a.dts (100%)
>  rename arch/arm64/boot/dts/{ => arm}/rtsm_ve-motherboard.dtsi (100%)
>  create mode 100644 scripts/Makefile.dtbinst
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
