Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3J2FfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab3J2FfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:35:17 -0400
Date: Tue, 29 Oct 2013 13:34:27 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org, bp@alien8.de
Subject: Re: [patch 5/6] export efi runtime memory mapping to sysfs
Message-ID: <20131029053427.GH5185@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.442470867@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027035923.442470867@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/13 at 11:47am, Dave Young wrote:
> kexec kernel will need exactly same mapping for
> efi runtime memory ranges. Thus here export the
> runtime ranges mapping to sysfs, kexec-tools
> will assemble them and pass to 2nd kernel via
> setup_data.
> 
> Introducing a new directly /sys/firmware/efi/efi-runtime-map
> Just like /sys/firmware/memmap. Containing below attribute
> in each file of that directory:
> attribute  num_pages  phys_addr  type  virt_addr
> 
> It will not work for efi 32bit. Only x86_64 currently.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/include/asm/efi.h             |    3 
>  arch/x86/platform/efi/efi.c            |   11 ++
>  drivers/firmware/efi/Kconfig           |   10 +
>  drivers/firmware/efi/Makefile          |    1 
>  drivers/firmware/efi/efi-runtime-map.c |  166 +++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c             |    3 
>  6 files changed, 193 insertions(+), 1 deletion(-)

Remind myself: add below to Documentaion in next version:
Documentation/ABI/testing/sysfs-efi-runtime-map
