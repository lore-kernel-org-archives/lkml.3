Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3I3UmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:42:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38929 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab3I3UmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:42:03 -0400
Date: Mon, 30 Sep 2013 22:41:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130930204154.GE19411@pd.tnic>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
 <20130926031242.GA4487@dhcp-16-126.nay.redhat.com>
 <20130930201730.GD16383@pd.tnic>
 <20130930203505.GA6116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130930203505.GA6116@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:35:05PM -0400, Vivek Goyal wrote:
> On Mon, Sep 30, 2013 at 10:17:30PM +0200, Borislav Petkov wrote:
> > On Thu, Sep 26, 2013 at 11:12:42AM +0800, Dave Young wrote:
> > > If we choose this approach, can we save not only the efi_mapping, but
> > > also the fields which will be converted to virt addr, like fw_vendor,
> > > runtime, tables? During my test on a HP workstation, the config table
> > > item (SMBIOS) also is converted to virt addr though spec only mention
> > > fw_vendor/runtime/tables.
> > 
> > Btw, I was about to ask: how do you pass boot_params to the kexec
> > kernel?
> 
> kexec-tools in user space prepares the boot_params and passes it to
> second kernel.

Ok, thanks.

hpa, so, for the struct efi_mapping thing to work, I will have to grep
dmesg of the first kernel to get an output like the one below, filter
the runtime regions so that I can build the struct efi_mapping array of
mem regions which I pass on to the second, kexec kernel with setup_data.

Unless you have a better idea, of course... :)

[    0.000000] efi: EFI v2.00 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xac812f98  SMBIOS=0xac573018 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x000000000004e000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x000000000004e000-0x0000000000060000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x0000000000060000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=2, attr=0xf, range=[0x0000000000100000-0x000000000058b000) (4MB)
[    0.000000] efi: mem05: type=7, attr=0xf, range=[0x000000000058b000-0x0000000001000000) (10MB)
[    0.000000] efi: mem06: type=4, attr=0xf, range=[0x0000000001000000-0x0000000001020000) (0MB)
[    0.000000] efi: mem07: type=7, attr=0xf, range=[0x0000000001020000-0x00000000378fe000) (872MB)
[    0.000000] efi: mem08: type=2, attr=0xf, range=[0x00000000378fe000-0x0000000037c77000) (3MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x0000000037c77000-0x000000007d6a8000) (1114MB)
[    0.000000] efi: mem10: type=2, attr=0xf, range=[0x000000007d6a8000-0x00000000a7420000) (669MB)
[    0.000000] efi: mem11: type=1, attr=0xf, range=[0x00000000a7420000-0x00000000a743d000) (0MB)
[    0.000000] efi: mem12: type=4, attr=0xf, range=[0x00000000a743d000-0x00000000a7495000) (0MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x00000000a7495000-0x00000000a74be000) (0MB)
[    0.000000] efi: mem14: type=4, attr=0xf, range=[0x00000000a74be000-0x00000000a74ef000) (0MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x00000000a74ef000-0x00000000a74f2000) (0MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x00000000a74f2000-0x00000000a79db000) (4MB)
[    0.000000] efi: mem17: type=6, attr=0x800000000000000f, range=[0x00000000a79db000-0x00000000a99dc000) (32MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000a99dc000-0x00000000a9ca1000) (2MB)
[    0.000000] efi: mem19: type=7, attr=0xf, range=[0x00000000a9ca1000-0x00000000a9ca3000) (0MB)
[    0.000000] efi: mem20: type=4, attr=0xf, range=[0x00000000a9ca3000-0x00000000abf12000) (34MB)
[    0.000000] efi: mem21: type=7, attr=0xf, range=[0x00000000abf12000-0x00000000ac0a6000) (1MB)
[    0.000000] efi: mem22: type=3, attr=0xf, range=[0x00000000ac0a6000-0x00000000ac512000) (4MB)
[    0.000000] efi: mem23: type=7, attr=0xf, range=[0x00000000ac512000-0x00000000ac529000) (0MB)
[    0.000000] efi: mem24: type=5, attr=0x800000000000000f, range=[0x00000000ac529000-0x00000000ac54c000) (0MB)
[    0.000000] efi: mem25: type=7, attr=0xf, range=[0x00000000ac54c000-0x00000000ac566000) (0MB)
[    0.000000] efi: mem26: type=6, attr=0x800000000000000f, range=[0x00000000ac566000-0x00000000ac569000) (0MB)
[    0.000000] efi: mem27: type=7, attr=0xf, range=[0x00000000ac569000-0x00000000ac56a000) (0MB)
[    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x00000000ac56a000-0x00000000ac576000) (0MB)
[    0.000000] efi: mem29: type=7, attr=0xf, range=[0x00000000ac576000-0x00000000ac596000) (0MB)
[    0.000000] efi: mem30: type=0, attr=0xf, range=[0x00000000ac596000-0x00000000ac5fb000) (0MB)
[    0.000000] efi: mem31: type=7, attr=0xf, range=[0x00000000ac5fb000-0x00000000ac6b7000) (0MB)
[    0.000000] efi: mem32: type=10, attr=0xf, range=[0x00000000ac6b7000-0x00000000ac7e3000) (1MB)
[    0.000000] efi: mem33: type=7, attr=0xf, range=[0x00000000ac7e3000-0x00000000ac7e4000) (0MB)
[    0.000000] efi: mem34: type=10, attr=0xf, range=[0x00000000ac7e4000-0x00000000ac7fb000) (0MB)
[    0.000000] efi: mem35: type=7, attr=0xf, range=[0x00000000ac7fb000-0x00000000ac80a000) (0MB)
[    0.000000] efi: mem36: type=2, attr=0xf, range=[0x00000000ac80a000-0x00000000ac810000) (0MB)
[    0.000000] efi: mem37: type=9, attr=0xf, range=[0x00000000ac810000-0x00000000ac813000) (0MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x00000000ac813000-0x00000000ac81a000) (0MB)
[    0.000000] efi: mem39: type=3, attr=0xf, range=[0x00000000ac81a000-0x00000000ad7ef000) (15MB)
[    0.000000] efi: mem40: type=4, attr=0xf, range=[0x00000000ad7ef000-0x00000000ad7f6000) (0MB)
[    0.000000] efi: mem41: type=3, attr=0xf, range=[0x00000000ad7f6000-0x00000000ad800000) (0MB)
[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13568MB)
[    0.000000] efi: mem43: type=11, attr=0x8000000000000001, range=[0x00000000b0000000-0x00000000b4000000) (64MB)
[    0.000000] efi: mem44: type=11, attr=0x8000000000000001, range=[0x00000000fed20000-0x00000000fed40000) (0MB)
[    0.000000] efi: mem45: type=11, attr=0x8000000000000001, range=[0x00000000fed50000-0x00000000fed90000) (0MB)
[    0.000000] efi: mem46: type=11, attr=0x8000000000000000, range=[0x00000000ffa00000-0x00000000ffa40000) (0MB)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
