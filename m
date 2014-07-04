Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaGDImQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:42:16 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:51252 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGDImN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140704164251.7dc67e07@canb.auug.org.au>
References: <20140704164251.7dc67e07@canb.auug.org.au>
Date: Fri, 4 Jul 2014 14:12:11 +0530
Message-ID: <CAK5sBcGq54sOSzJKXrEbhAUTZZh=+9NuVh294Qxn0dQvbh-G8w@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 4
From: Sachin Kamat <spk.linux@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Was bisecting a kernel crash on Arndale octa board (Exynos5420). It
points to a merge
commit:
40556a4c485d12d324f1ea196cc30f590e564237 is the first bad commit
("Merge remote-tracking branch 'nfsd/nfsd-next'").

How do I proceed with this?

Bisect log as follows:

git bisect start
# good: [4c834452aad01531db949414f94f817a86348d59] Linux 3.16-rc3
git bisect good 4c834452aad01531db949414f94f817a86348d59
# bad: [bb62c798798659624c53e3727bbc18cf47eb7ae8] Add linux-next
specific files for 20140704
git bisect bad bb62c798798659624c53e3727bbc18cf47eb7ae8
# bad: [de5ea10b7647b299d27a40511772f024629b466d] Merge
remote-tracking branch 'md/for-next'
git bisect bad de5ea10b7647b299d27a40511772f024629b466d
# bad: [3ca365b4451d1bab28adc72a985d9bbdf535df0e] Merge
remote-tracking branch 'dmaengine/next'
git bisect bad 3ca365b4451d1bab28adc72a985d9bbdf535df0e
# good: [d72d4e47cb1e8ac1259a5f5935320ae1e7022066] Merge
remote-tracking branch 'renesas/next'
git bisect good d72d4e47cb1e8ac1259a5f5935320ae1e7022066
# good: [fdb82f0a3d19eaa0661d799b980d0a9b689fcf75] Merge
remote-tracking branch 'nfs/linux-next'
git bisect good fdb82f0a3d19eaa0661d799b980d0a9b689fcf75
# bad: [fc48eed8cd350e4be1227ff3c990d48906afd00a] Merge
remote-tracking branch 'hwmon-staging/hwmon-next'
git bisect bad fc48eed8cd350e4be1227ff3c990d48906afd00a
# bad: [7d3f94ee2f2808b13dd3a96f6e6ca754a954d4b9] Merge
remote-tracking branch 'ubifs/linux-next'
git bisect bad 7d3f94ee2f2808b13dd3a96f6e6ca754a954d4b9
# good: [8cdb8b21b1d00856b885734c514821627c8078bc] NFSD: Avoid warning
message when compile at i686 arch
git bisect good 8cdb8b21b1d00856b885734c514821627c8078bc
# good: [da575690c01993471e38faf3eee1991ee69d7b20] nfsd: clean up
nfsd4_close_open_stateid
git bisect good da575690c01993471e38faf3eee1991ee69d7b20
# good: [95217c1e686bdd7c27b8483bbdda1c09d6fa9a92] nfsd: Don't get a
session reference without a client reference
git bisect good 95217c1e686bdd7c27b8483bbdda1c09d6fa9a92
# good: [bdd79ee31bf842051365c798effaffe0e647b501] nfsd: Allow struct
nfsd4_compound_state to cache the nfs4_client
git bisect good bdd79ee31bf842051365c798effaffe0e647b501
# good: [e9110361a9a4e258b072b14bd44eb78cf11453cb] UBI: fix the
volumes tree sorting criteria
git bisect good e9110361a9a4e258b072b14bd44eb78cf11453cb
# bad: [40556a4c485d12d324f1ea196cc30f590e564237] Merge
remote-tracking branch 'nfsd/nfsd-next'
git bisect bad 40556a4c485d12d324f1ea196cc30f590e564237

Regards,
Sachin.

On Fri, Jul 4, 2014 at 12:12 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20140703:
>
> My fixes tree contains:
>         powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
>
> The net tree gained a build failure for which I reverted a commit.
>
> The usb-gadget tree gained a conflict against the usb.current tree.
>
> The staging tree still had its build failure for which I disabled a driver.
>
> The akpm-current tree still had its build failure for which I applied a
> patch.
>
> Non-merge commits (relative to Linus' tree): 3478
>  3383 files changed, 134181 insertions(+), 185822 deletions(-)
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" and checkout or reset to the new
> master.
>
