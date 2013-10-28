Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3J1K1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:27:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46162 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470Ab3J1K1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:27:12 -0400
Date: Mon, 28 Oct 2013 10:27:05 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 2/6] x86 efi: reserve boot service fix
Message-ID: <20131028102705.GI1982@console-pimps.org>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.924386710@dhcp-16-126.nay.redhat.com>
 <20131027105009.GA21868@pd.tnic>
 <20131027203058.GE1982@console-pimps.org>
 <20131028011824.GD4397@dhcp-16-126.nay.redhat.com>
 <20131028084440.GA4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028084440.GA4314@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct, at 09:44:41AM, Borislav Petkov wrote:
> On Mon, Oct 28, 2013 at 09:18:24AM +0800, Dave Young wrote:
> > There should be some people see below message with non-kexec kernel:
> > "Could not reserve boot range ..."
> 
> I can find one other report like that: https://lkml.org/lkml/2013/7/16/309
> 
> [    0.000000] efi: Could not reserve boot range [0x0000000000-0x0000000fff]
> 
> for
> 
> efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
> 
> which is EFI_BOOT_SERVICES_CODE and
> 
> efi: Could not reserve boot range [0x000005f000-0x000009ffff]
> 
> for
> 
> efi: mem06: type=3, attr=0xf, range=[0x000000000005f000-0x00000000000a0000) (0MB)
> 
> which is of the same type.
 
But that doesn't look like the issue that the user was complaining
about. Rather, it's that the higher EFI regions are unable to be mapped
because of the user's mem= kernel parameter setting.

However, even though this bug isn't the main focus of the above report,
since people are hitting it (and since the fix is trivial), I agree it's
worth tagging for stable.

-- 
Matt Fleming, Intel Open Source Technology Center
