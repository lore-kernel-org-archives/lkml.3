Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3LMUEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:04:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52885 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3LMUEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:04:23 -0500
Date: Fri, 13 Dec 2013 21:04:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 12/14] x86: export x86 boot_params to sysfs
Message-ID: <20131213200412.GA12466@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-13-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386582147-9802-13-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:42:25PM +0800, Dave Young wrote:
> kexec-tools use boot_params for getting the 1st kernel hardware_subarch,
> the kexec kernel efi runtime support also need read the old efi_info from
> boot_params. Currently it exists in debugfs which is not a good place for
> such infomation. Per HPA, we should avoid of "sploit debugfs".
> 
> In this patch /sys/kernel/boot_params are exported, also the setup_data is
> exported as a subdirectory. kexec-tools is using debugfs for hardware_subarch
> for a long time now so we're not removing it yet.
> 
> Structure is like below:
> 
> /sys/kernel/boot_params
> |__ data                /* boot_params in binary*/
> |__ setup_data
> |   |__ 0               /* the first setup_data node */
> |   |   |__ data        /* setup_data node 0 in binary*/
> |   |   |__ type        /* setup_data type of setup_data node 0, hex string */
> [snip]
> |__ version             /* boot protocal version (in hex, "0x" prefixed)*/
> 
> Changelog:
> Greg: use __ATTR_RO() and group attr.
> Matt and Boris: Documentation improvement, code indentation.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
