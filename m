Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3KMPuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:50:44 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:32862 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932380Ab3KMPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:50:36 -0500
Date: Wed, 13 Nov 2013 15:50:32 +0000
From: Matt Fleming <matt@console-pimps.org>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 6/7 v2] passing kexec necessary efi data via setup_data
Message-ID: <20131113155032.GD17248@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082718.837997775@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105082718.837997775@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Nov, at 04:20:13PM, dyoung@redhat.com wrote:
> Add a new setup_data type SETUP_EFI for kexec use.
> Passing the saved fw_vendor, runtime, config tables and
> efi runtime mappings.
> 
> When entering virtual mode, directly mapping the efi
> runtime ragions which we passed in previously. And skip
> the step to call SetVirtualAddressMap.
> 
> Specially for HP z420 workstation it need another variable
> saving, it's the smbios physical address, the HP bios
> also update the SMBIOS address after entering virtual mode
> besides of the standard fw_vendor,runtime and config table.
 
Does that mean that on some of the platforms you tested the SMBIOS
address isn't updated?

-- 
Matt Fleming, Intel Open Source Technology Center
