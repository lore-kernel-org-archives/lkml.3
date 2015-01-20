Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbbATU0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:26:53 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41425 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbATU0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:26:51 -0500
Date: Tue, 20 Jan 2015 12:26:42 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: linux-next: Tree for Jan 20
Message-ID: <20150120202642.GA6178@roeck-us.net>
References: <20150120185308.53f4af4e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120185308.53f4af4e@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020203.54BEBA0B.010F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 2
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 3
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 06:53:08PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150119:
> 
> The omap tree gained a conflict against the arm-soc tree.
> 
> The net-next tree lost its build failure.
> 
> The mmc-uh tree gained a conflict against the sunxi tree.
> 
> The audit tree gained conflicts against Linus' tree.
> 
> Non-merge commits (relative to Linus' tree): 3975
>  3828 files changed, 141642 insertions(+), 68217 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
I ran bisect with some of the qemu failures. Here are the results.

If you are copied on this e-mail and you are not Stephen, your patch is
one of the culprits.

Guenter

---
microblaze:

# bad: [5d0eebbbb6f76de160f7d7f9dc0b64a98ad9b8e9] Add linux-next specific files for 20150120
# good: [ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc] Linux 3.19-rc5
git bisect start 'HEAD' 'v3.19-rc5'
# good: [f933e94e8f597c709068e58daa92570d5aa13b8c] Merge remote-tracking branch 'drm/drm-next'
git bisect good f933e94e8f597c709068e58daa92570d5aa13b8c
# bad: [88cf70c4dd4a3851bf5531c0a51dec298d9690b5] Merge remote-tracking branch 'usb/usb-next'
git bisect bad 88cf70c4dd4a3851bf5531c0a51dec298d9690b5
# good: [2d750b9c3a68dc83b364d08f06a983bbb2c57a9a] Merge remote-tracking branch 'device-mapper/for-next'
git bisect good 2d750b9c3a68dc83b364d08f06a983bbb2c57a9a
# bad: [750fa2b454770b2f3444ef4b266772f5d047be29] Merge remote-tracking branch 'spi/for-next'
git bisect bad 750fa2b454770b2f3444ef4b266772f5d047be29
# good: [4df61d072e10a5c1c15979b689148f21f33f44fb] Merge remote-tracking branch 'regulator/for-next'
git bisect good 4df61d072e10a5c1c15979b689148f21f33f44fb
# bad: [2a0a8e653fd1232f5505d007d66ec8605270d610] Merge remote-tracking branch 'audit/next'
git bisect bad 2a0a8e653fd1232f5505d007d66ec8605270d610
# good: [c03155e83fbf2b64e960c0bc93c2958aaf9b048b] Merge remote-tracking branch 'iommu/next'
git bisect good c03155e83fbf2b64e960c0bc93c2958aaf9b048b
# good: [174236285cf849f85a31b3da875c2e939d7cdb15] Merge branch 'doc/sp-update' into docs-next
git bisect good 174236285cf849f85a31b3da875c2e939d7cdb15
# bad: [49463ee9d92926079992f4a34de9ea7ef8cc182c] audit: replace getname()/putname() hacks with reference counters
git bisect bad 49463ee9d92926079992f4a34de9ea7ef8cc182c
# bad: [5dc5218840e1268de639150a851978bb19c341df] fs: create proper filename objects using getname_kernel()
git bisect bad 5dc5218840e1268de639150a851978bb19c341df
# good: [33498e62156b59be4dce6a260743ad9d1660037f] fs: rework getname_kernel to handle up to PATH_MAX sized filenames
git bisect good 33498e62156b59be4dce6a260743ad9d1660037f
# first bad commit: [5dc5218840e1268de639150a851978bb19c341df] fs: create proper filename objects using getname_kernel()

---
mips:

# bad: [5d0eebbbb6f76de160f7d7f9dc0b64a98ad9b8e9] Add linux-next specific files for 20150120
# good: [ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc] Linux 3.19-rc5
git bisect start 'HEAD' 'v3.19-rc5'
# good: [f933e94e8f597c709068e58daa92570d5aa13b8c] Merge remote-tracking branch 'drm/drm-next'
git bisect good f933e94e8f597c709068e58daa92570d5aa13b8c
# good: [88cf70c4dd4a3851bf5531c0a51dec298d9690b5] Merge remote-tracking branch 'usb/usb-next'
git bisect good 88cf70c4dd4a3851bf5531c0a51dec298d9690b5
# good: [3ee33b3893f72e5a504ba873ee4a308896d97645] Merge remote-tracking branch 'cgroup/for-next'
git bisect good 3ee33b3893f72e5a504ba873ee4a308896d97645
# bad: [5925961a2889ec2b3734be9f3a6375822010f7a7] fs-befs-linuxvfsc-remove-unnecessary-casting-fix
git bisect bad 5925961a2889ec2b3734be9f3a6375822010f7a7
# bad: [fff9d1d082bb48a0d0e89aaaf746718fcef3a47f] mm: memcontrol: default hierarchy interface for memory fix
git bisect bad fff9d1d082bb48a0d0e89aaaf746718fcef3a47f
# bad: [ab090dcbdd276e9ddcd0ecb666389aa85c30c76f] powerpc: drop _PAGE_FILE and pte_file()-related helpers
git bisect bad ab090dcbdd276e9ddcd0ecb666389aa85c30c76f
# good: [b44330a2df410b2e1e46a0bef1b7d2e8952757a2] block: restore /proc/partitions to not display non-partitionable removable devices
git bisect good b44330a2df410b2e1e46a0bef1b7d2e8952757a2
# bad: [d22cd75c416aa577561454a4d36ff842bb30d26a] arm64: drop PTE_FILE and pte_file()-related helpers
git bisect bad d22cd75c416aa577561454a4d36ff842bb30d26a
# bad: [76f0255272b623728e6f7810f43bfc2c2e70c0ea] mm: drop vm_ops->remap_pages and generic_file_remap_pages() stub
git bisect bad 76f0255272b623728e6f7810f43bfc2c2e70c0ea
# bad: [0bf4c1caa14e3fa95d83da14846f2bfc421dc53f] mm: don't use compound_head() in virt_to_head_page()
git bisect bad 0bf4c1caa14e3fa95d83da14846f2bfc421dc53f
# good: [8e32336269fb0dee55c839611a97356750cc6f05] fs-make-generic_block_fiemap-sig-tolerant-fix
git bisect good 8e32336269fb0dee55c839611a97356750cc6f05
# bad: [d2dc80750ee05ceb03c9b13b0531a782116d1ade] mm/slub: optimize alloc/free fastpath by removing preemption on/off
git bisect bad d2dc80750ee05ceb03c9b13b0531a782116d1ade
# first bad commit: [d2dc80750ee05ceb03c9b13b0531a782116d1ade] mm/slub: optimize alloc/free fastpath by removing preemption on/off

---
sparc:

# bad: [5d0eebbbb6f76de160f7d7f9dc0b64a98ad9b8e9] Add linux-next specific files for 20150120
# good: [ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc] Linux 3.19-rc5
git bisect start 'HEAD' 'v3.19-rc5'
# good: [f933e94e8f597c709068e58daa92570d5aa13b8c] Merge remote-tracking branch 'drm/drm-next'
git bisect good f933e94e8f597c709068e58daa92570d5aa13b8c
# good: [88cf70c4dd4a3851bf5531c0a51dec298d9690b5] Merge remote-tracking branch 'usb/usb-next'
git bisect good 88cf70c4dd4a3851bf5531c0a51dec298d9690b5
# good: [3ee33b3893f72e5a504ba873ee4a308896d97645] Merge remote-tracking branch 'cgroup/for-next'
git bisect good 3ee33b3893f72e5a504ba873ee4a308896d97645
# bad: [5925961a2889ec2b3734be9f3a6375822010f7a7] fs-befs-linuxvfsc-remove-unnecessary-casting-fix
git bisect bad 5925961a2889ec2b3734be9f3a6375822010f7a7
# bad: [fff9d1d082bb48a0d0e89aaaf746718fcef3a47f] mm: memcontrol: default hierarchy interface for memory fix
git bisect bad fff9d1d082bb48a0d0e89aaaf746718fcef3a47f
# good: [ab090dcbdd276e9ddcd0ecb666389aa85c30c76f] powerpc: drop _PAGE_FILE and pte_file()-related helpers
git bisect good ab090dcbdd276e9ddcd0ecb666389aa85c30c76f
# good: [91408e6db5842ed4bb66e2a3919b67a5f06ac34a] mm/hugetlb: fix suboptimal migration/hwpoisoned entry check
git bisect good 91408e6db5842ed4bb66e2a3919b67a5f06ac34a
# bad: [8e94896c7510e69bbd2acf418ad3a8afb9978c97] fs: consolidate {nr,free}_cached_objects args in shrink_control
git bisect bad 8e94896c7510e69bbd2acf418ad3a8afb9978c97
# bad: [5995b76d501a8f4d315f811698db98ac997d706f] x86: mm: restore original pte_special check
git bisect bad 5995b76d501a8f4d315f811698db98ac997d706f
# good: [b75c721aa3e2df5c52d4b6bce3dd687018c1f40c] mm: convert p[te|md]_numa users to p[te|md]_protnone_numa
git bisect good b75c721aa3e2df5c52d4b6bce3dd687018c1f40c
# good: [ce4188d335ac91a004087fb0ea86b85091ad570b] mm: convert p[te|md]_mknonnuma and remaining page table manipulations
git bisect good ce4188d335ac91a004087fb0ea86b85091ad570b
# bad: [625fa33ba695d73baa58afa44ab063f67e5f4b64] mm: numa: do not trap faults on the huge zero page
git bisect bad 625fa33ba695d73baa58afa44ab063f67e5f4b64
# good: [c2a7c97cc4bc3d46e98908d7dee07ab3e00a5257] mm: remove remaining references to NUMA hinting bits and helpers
git bisect good c2a7c97cc4bc3d46e98908d7dee07ab3e00a5257
# first bad commit: [625fa33ba695d73baa58afa44ab063f67e5f4b64] mm: numa: do not trap faults on the huge zero page
