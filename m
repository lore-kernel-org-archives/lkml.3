Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3J1Ior (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:44:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33272 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab3J1Iop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:44:45 -0400
Date: Mon, 28 Oct 2013 09:44:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 2/6] x86 efi: reserve boot service fix
Message-ID: <20131028084440.GA4314@pd.tnic>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.924386710@dhcp-16-126.nay.redhat.com>
 <20131027105009.GA21868@pd.tnic>
 <20131027203058.GE1982@console-pimps.org>
 <20131028011824.GD4397@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131028011824.GD4397@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 09:18:24AM +0800, Dave Young wrote:
> There should be some people see below message with non-kexec kernel:
> "Could not reserve boot range ..."

I can find one other report like that: https://lkml.org/lkml/2013/7/16/309

[    0.000000] efi: Could not reserve boot range [0x0000000000-0x0000000fff]

for

efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)

which is EFI_BOOT_SERVICES_CODE and

efi: Could not reserve boot range [0x000005f000-0x000009ffff]

for

efi: mem06: type=3, attr=0xf, range=[0x000000000005f000-0x00000000000a0000) (0MB)

which is of the same type.

> But it's hard for them to notice the bad functionality because
> it's only one mem range which might be not the boot range what
> SetVirtualAddressMap need

Right.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
