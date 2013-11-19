Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab3KSMSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:18:20 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:55436 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab3KSMSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:18:18 -0500
Date: Tue, 19 Nov 2013 12:18:14 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 5/7 v2] export efi runtime memory mapping to sysfs
Message-ID: <20131119121814.GB11521@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082718.185728964@dhcp-16-126.nay.redhat.com>
 <20131113155027.GC17248@console-pimps.org>
 <20131114015047.GD4081@dhcp-16-126.nay.redhat.com>
 <20131118021641.GC4025@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118021641.GC4025@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov, at 10:16:41AM, Dave Young wrote:
> Matt, desc_version is already in boot_params.efi_info, so kexec-tools
> can get the version from there. I do not need to export it as another
> file.
 
OK, cool.

> I think for now we do not need worry much about the compatibility
> issue, do you think I need add version checking in kexec-tools
> currently? like below?
> 
> if (desc_version != 1) /* current version is 1? */
> 	error out it is not supported

Yes, something like that. If you already have kexec-specific ways of
checking a version number then that's fine. Just make sure that, if the
EFI memory descriptor structure is extended in the future and more files
are exported for each descriptor, kexec-tools say "I don't know how to
build a data structure for from these files".

-- 
Matt Fleming, Intel Open Source Technology Center
