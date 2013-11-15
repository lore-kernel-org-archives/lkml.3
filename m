Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3KOXGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:06:52 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:2121 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3KOXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:06:45 -0500
Message-ID: <1384556525.1791.4.camel@misato.fc.hp.com>
Subject: Re: [patch 1/7 v2] Add function efi_remap_region for remapping to
 saved virt address
From: Toshi Kani <toshi.kani@hp.com>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Date: Fri, 15 Nov 2013 16:02:05 -0700
In-Reply-To: <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
	 <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 16:20 +0800, dyoung@redhat.com wrote:
> Kexec kernel will use saved runtime virtual mapping, so add a
> new function efi_remap_region to remapping it directly without
> calculate the virt addr from efi_va.
> 
> The md is passed in from 1st kernel, the virtual addr is
> saved in md->virt_addr.

 :

> +/*
> + * kexec kernel will use efi_map_region_fixed to map efi
> + * runtime memory ranges. md->virt_addr is the original virtual
> + * address which had been mapped in kexec 1st kernel.
> + */
> +void __init efi_map_region_fixed(efi_memory_desc_t *md)

Can you simply use __map_region() instead of creating this function?
Both functions seem to do the same thing.  (In __map_region(), size and
end are not used.)

Thanks,
-Toshi

