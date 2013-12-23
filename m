Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab3LWGKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:10:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3LWGKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:10:41 -0500
Date: Mon, 23 Dec 2013 14:09:50 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131223060950.GA9279@dhcp-16-126.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
 <20131221160416.GD29501@console-pimps.org>
 <20131223020958.GB3760@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131223020958.GB3760@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do we actually need the 'map' entry in efi_setup_data now that you're
> > passing it via efi_info (which is much better approach!)? Also, we don't
> > need the global nr_efi_runtime_map or efi_runtime_map variables now,
> > right?
> 
> The map is still necessary because we need store the map somewhere and pass
> the physicall address to kexec kernel. Passing them in setup_data is the
> only better way currently...
> 
> In efi_info there's only an entry for the map physical address, the original
> map area is not valid any more.

For kexec kernel it might be ok to use the old map area, but for kdump kernel
we can only use the memory which is early reserved with crashkernel= cmdline.

Thanks
Dave
