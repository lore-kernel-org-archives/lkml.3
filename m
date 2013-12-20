Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3LTB6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:58:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3LTB63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:58:29 -0500
Date: Fri, 20 Dec 2013 09:57:47 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v6 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131220015747.GA7128@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-11-git-send-email-dyoung@redhat.com>
 <20131219164144.GG3145@console-pimps.org>
 <20131220013508.GA3795@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220013508.GA3795@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 at 09:35am, Dave Young wrote:
> On 12/19/13 at 04:41pm, Matt Fleming wrote:
> > On Mon, 16 Dec, at 05:30:31PM, Dave Young wrote:
> > > For kexec/kdump kernel efi runtime mappings are saved, printing original whole
> > > memmap ranges does not make sense anymore. So introduce a new function to only
> > > print runtime maps in case kexec/kdump kernel is used.
> > > 
> > > changelog:
> > > Matt: use efi_setup instead of esdata
> > >       share function print_efi_memmap for both normal and kexec boot.
> > > 
> > > Signed-off-by: Dave Young <dyoung@redhat.com>
> > > ---
> > >  arch/x86/platform/efi/efi.c | 24 +++++++++++++++++-------
> > >  1 file changed, 17 insertions(+), 7 deletions(-)
> > 
> > Thinking about this a bit more, I'm not at all sure why this patch
> > exists.
> > 
> > Why do we not want to print the entire memory map range like we did in
> > the first kernel? The e820 map is printed exactly like it was in the
> > first kernel, why should the EFI memmap be special?
> 
> Hi, Matt
> 
> Here is the memmap.map print result in kexec kernel (qemu + ovmf).
> I think the memmap.map is not valid any more in kexec kernel, thus we
> should print the saved runtime map.

I have another idea to cleanup the code, that is update efi_info in
userspace kexec-tools, make memmap.map point to saved runtime map in
setup_data, thus the kernel part will be more simple.

Working on it..

> 
> [    0.000000] efi: EFI v2.31 by EDK II
> [    0.000000] efi:  ACPI=0x1f9e0000  ACPI 2.0=0x1f9e0014 
> [    0.000000] efi: mem00: type=33490747, attr=0x1ff073c, range=[0xffffffff8105542e-0xfffff80fd649d42e) (72057594029606228MB)
> [    0.000000] efi: mem01: type=33490747, attr=0x10756, range=[0xffffffff8105548e-0xfffff80fd650d48e) (72057594029606228MB)
> [    0.000000] efi: mem02: type=67410, attr=0x10758, range=[0xffffffff81055548-0xfffff80fd6630548) (72057594029606229MB)
> [    0.000000] efi: mem03: type=67416, attr=0x1ff0749, range=[0xffffffff810556c2-0xfffff80fd67246c2) (72057594029606230MB)
> [    0.000000] efi: mem04: type=67416, attr=0x10756, range=[0xffffffff810557d1-0xfffff80fd685d7d1) (72057594029606232MB)
> [    0.000000] efi: mem05: type=67410, attr=0x10756, range=[0xffffffff8105584a-0xfffff80fd68b684a) (72057594029606232MB)
> [    0.000000] efi: mem06: type=67415, attr=0x10758, range=[0xffffffff810558b7-0xfffff80fd69168b7) (72057594029606232MB)
> [    0.000000] efi: mem07: type=67417, attr=0x10758, range=[0xffffffff810558fa-0xfffff80fd697c8fa) (72057594029606233MB)
> [    0.000000] efi: mem08: type=67415, attr=0x10758, range=[0xffffffff810559c2-0xfffff80fd6a6b9c2) (72057594029606234MB)
> [    0.000000] efi: mem09: type=67417, attr=0x10754, range=[0xffffffff81055a4f-0xfffff80fd6b2fa4f) (72057594029606234MB)
> [    0.000000] efi: mem10: type=33490778, attr=0x10753, range=[0xffffffff81055b66-0xfffff80fd6c49b66) (72057594029606235MB)
> [    0.000000] efi: mem11: type=67417, attr=0x10753, range=[0xffffffff81055c75-0xfffff80fd6d0dc75) (72057594029606236MB)
> [    0.000000] efi: mem12: type=67411, attr=0x10759, range=[0xffffffff81055dc2-0xfffff80fd6e38dc2) (72057594029606237MB)
> [    0.000000] efi: mem13: type=33490773, attr=0x1ff075a, range=[0xffffffff81055e3e-0xfffff80fd6ea1e3e) (72057594029606238MB)
> [    0.000000] efi: mem14: type=67409, attr=0x10752, range=[0xffffffff81056053-0xfffff80fd7163053) (72057594029606241MB)
> [    0.000000] efi: mem15: type=67409, attr=0x1ff0747, range=[0xffffffff8105612b-0xfffff80fd719012b) (72057594029606241MB)
> [    0.000000] efi: mem16: type=67409, attr=0x10751, range=[0xffffffff8105628c-0xfffff80fd73a828c) (72057594029606243MB)
> [    0.000000] efi: mem17: type=67410, attr=0x10751, range=[0xffffffff81056441-0xfffff80fd74ff441) (72057594029606244MB)
> [    0.000000] efi: mem18: type=67410, attr=0x10752, range=[0xffffffff8105652a-0xfffff80fd761152a) (72057594029606245MB)
> [    0.000000] efi: mem19: type=33490748, attr=0x1072c, range=[0xffffffff810565e6-0xfffff80fd79dc5e6) (72057594029606249MB)
> [    0.000000] efi: mem20: type=67409, attr=0x10751, range=[0xffffffff81056a25-0xfffff80fd7ae0a25) (72057594029606250MB)
> [    0.000000] efi: mem21: type=67372, attr=0x1ff073b, range=[0xffffffff8105745c-0xfffff80fd84bc45c) (72057594029606260MB)
> [    0.000000] efi: mem22: type=33490720, attr=0x1ff0744, range=[0xffffffff81057a3a-0xfffff80fd95d8a3a) (72057594029606277MB)
> [    0.000000] efi: mem23: type=33490757, attr=0x1ff073f, range=[0xffffffff81058659-0xfffff80fd9734659) (72057594029606278MB)
> [    0.000000] efi: mem24: type=33490752, attr=0x1ff074b, range=[0xffffffff81058867-0xfffff80fd98e1867) (72057594029606280MB)
> [    0.000000] efi: mem25: type=67410, attr=0x10751, range=[0xffffffff810589d9-0xfffff80fd9ac79d9) (72057594029606282MB)
> [    0.000000] efi: mem26: type=67414, attr=0x10753, range=[0xffffffff81058b4c-0xfffff80fd9c42b4c) (72057594029606283MB)
> [    0.000000] efi: mem27: type=67416, attr=0x1072c, range=[0xffffffff81058c85-0xfffff80fd9dffc85) (72057594029606285MB)
> [    0.000000] efi: mem28: type=67374, attr=0x1072d, range=[0xffffffff81058e41-0xfffff80fd9eb0e41) (72057594029606286MB)
> 
> 
> > 
> > -- 
> > Matt Fleming, Intel Open Source Technology Center
