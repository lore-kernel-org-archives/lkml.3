Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbbAUXeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:34:46 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39596 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbbAUXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:34:37 -0500
Date: Wed, 21 Jan 2015 15:34:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        davem@davemloft.net
Subject: Re: linux-next: Tree for Jan 20
Message-ID: <20150121233418.GA5081@roeck-us.net>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120202642.GA6178@roeck-us.net>
 <20150120225443.GA19629@node.dhcp.inet.fi>
 <54BF1785.7040300@roeck-us.net>
 <20150121104325.GA22449@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121104325.GA22449@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54C0378D.0009,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
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

On Wed, Jan 21, 2015 at 12:43:25PM +0200, Kirill A. Shutemov wrote:
> On Tue, Jan 20, 2015 at 07:05:41PM -0800, Guenter Roeck wrote:
> > On 01/20/2015 02:54 PM, Kirill A. Shutemov wrote:
> > >On Tue, Jan 20, 2015 at 12:26:42PM -0800, Guenter Roeck wrote:
> > >>---
> > >>sparc:
> > >>
> > >># bad: [5d0eebbbb6f76de160f7d7f9dc0b64a98ad9b8e9] Add linux-next specific files for 20150120
> > >># good: [ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc] Linux 3.19-rc5
> > >>git bisect start 'HEAD' 'v3.19-rc5'
> > >># good: [f933e94e8f597c709068e58daa92570d5aa13b8c] Merge remote-tracking branch 'drm/drm-next'
> > >>git bisect good f933e94e8f597c709068e58daa92570d5aa13b8c
> > >># good: [88cf70c4dd4a3851bf5531c0a51dec298d9690b5] Merge remote-tracking branch 'usb/usb-next'
> > >>git bisect good 88cf70c4dd4a3851bf5531c0a51dec298d9690b5
> > >># good: [3ee33b3893f72e5a504ba873ee4a308896d97645] Merge remote-tracking branch 'cgroup/for-next'
> > >>git bisect good 3ee33b3893f72e5a504ba873ee4a308896d97645
> > >># bad: [5925961a2889ec2b3734be9f3a6375822010f7a7] fs-befs-linuxvfsc-remove-unnecessary-casting-fix
> > >>git bisect bad 5925961a2889ec2b3734be9f3a6375822010f7a7
> > >># bad: [fff9d1d082bb48a0d0e89aaaf746718fcef3a47f] mm: memcontrol: default hierarchy interface for memory fix
> > >>git bisect bad fff9d1d082bb48a0d0e89aaaf746718fcef3a47f
> > >># good: [ab090dcbdd276e9ddcd0ecb666389aa85c30c76f] powerpc: drop _PAGE_FILE and pte_file()-related helpers
> > >>git bisect good ab090dcbdd276e9ddcd0ecb666389aa85c30c76f
> > >># good: [91408e6db5842ed4bb66e2a3919b67a5f06ac34a] mm/hugetlb: fix suboptimal migration/hwpoisoned entry check
> > >>git bisect good 91408e6db5842ed4bb66e2a3919b67a5f06ac34a
> > >># bad: [8e94896c7510e69bbd2acf418ad3a8afb9978c97] fs: consolidate {nr,free}_cached_objects args in shrink_control
> > >>git bisect bad 8e94896c7510e69bbd2acf418ad3a8afb9978c97
> > >># bad: [5995b76d501a8f4d315f811698db98ac997d706f] x86: mm: restore original pte_special check
> > >>git bisect bad 5995b76d501a8f4d315f811698db98ac997d706f
> > >># good: [b75c721aa3e2df5c52d4b6bce3dd687018c1f40c] mm: convert p[te|md]_numa users to p[te|md]_protnone_numa
> > >>git bisect good b75c721aa3e2df5c52d4b6bce3dd687018c1f40c
> > >># good: [ce4188d335ac91a004087fb0ea86b85091ad570b] mm: convert p[te|md]_mknonnuma and remaining page table manipulations
> > >>git bisect good ce4188d335ac91a004087fb0ea86b85091ad570b
> > >># bad: [625fa33ba695d73baa58afa44ab063f67e5f4b64] mm: numa: do not trap faults on the huge zero page
> > >>git bisect bad 625fa33ba695d73baa58afa44ab063f67e5f4b64
> > >># good: [c2a7c97cc4bc3d46e98908d7dee07ab3e00a5257] mm: remove remaining references to NUMA hinting bits and helpers
> > >>git bisect good c2a7c97cc4bc3d46e98908d7dee07ab3e00a5257
> > >># first bad commit: [625fa33ba695d73baa58afa44ab063f67e5f4b64] mm: numa: do not trap faults on the huge zero page
> > >
> > >Could you provide more info about the fail in qemu?
> > >
> > 
> > Error message:
> > 
> > BUG: Bad page state in process init.sh  pfn:00000
> > page:f05e7460 count:0 mapcount:-1 mapping:  (null) index:0x0
> > flags: 0x400(reserved)
> > page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> > bad because of flags:
> > flags: 0x400(reserved)
> > CPU: 0 PID: 1 Comm: init.sh Not tainted 3.19.0-rc5-next-20150120 #1
> > [f0076010 : bad_page+0xdc/0xfc ] [f00760c0 : free_pages_prepare+0x90/0x1f8 ] [f00775cc : free_hot_cold_page+0x20/0x160 ] [f00919e8 : do_wp_page+0x680/0x6ac ] [f00939f4 : handle_mm_fault+0xc94/0xd08 ] [f0015900 : do_sparc_fault+0xfc/0x3ec ] [f000af90 : srmmu_fault+0x58/0x68 ] [f00e74f4 : load_elf_binary+0x9a8/0xe94 ] [f00b0cac : search_binary_handler+0x68/0x12c ] [f00e67d0 : load_script+0x214/0x224 ] [f00b0cac : search_binary_handler+0x68/0x12c ] [f00b11a4 : do_execveat_common+0x434/0x584 ] [f00b1310 : do_execve+0x1c/0x2c ] [f02b50b0 : kernel_init+0x70/0xf0 ] [f000b200 : ret_from_kernel_thread+0xc/0x38 ] [00000000 :   (null) ]
> > Disabling lock debugging due to kernel taint
> > : applet not found
> > Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000100
> 
> It doesn't make much sense to me. It tries to free page with pfn==0 on
> handling wp-fault. How it got mapped in the first place?
> 
Let me know if I can help with any debugging.

Guenter
