Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3LMUFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:05:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52911 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3LMUFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:05:06 -0500
Date: Fri, 13 Dec 2013 21:04:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 13/14] x86: reserve setup_data ranges late after
 parsing memmap cmdline
Message-ID: <20131213200455.GB12466@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-14-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386582147-9802-14-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:42:26PM +0800, Dave Young wrote:
> Currently e820_reserve_setup_data is called before parsing early params,
> it works in normal case. But for memmap=exactmap, the final memory ranges
> are created after parsing memmap= cmdline params, so the previous
> e820_reserve_setup_data has no effect. For example, setup_data ranges
> will still be marked as normal system ram, thus when later sysfs driver
> ioremap them kernel will warn about mapping normal ram.
> 
> This patch fix it by moving the e820_reserve_setup_data callback after
> parsing early params so they can be set as reserved ranges and later
> ioremap will be fine with it.
> 
> changes:
> Boris: improve patch description
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
