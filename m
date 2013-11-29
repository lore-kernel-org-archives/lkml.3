Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3K2Q5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:57:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37493 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab3K2Q5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:57:06 -0500
Date: Fri, 29 Nov 2013 17:56:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 11/12] x86: reserve setup_data ranges late after
 parsing memmap cmdline
Message-ID: <20131129165656.GF4266@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-12-git-send-email-dyoung@redhat.com>
 <20131127150710.GH32267@pd.tnic>
 <20131129083551.GB4186@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131129083551.GB4186@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 04:35:52PM +0800, Dave Young wrote:
> Is below changes ok to you?

Almost perfect! Just a micro-nitpick below:

> Currently e820_reserve_setup_data is called before parsing early params,
> it works in normal case. But for memmap=exactmap, the final memory ranges
> are created after parsing memmap= cmdline params, so the previous
> e820_reserve_setup_data has no effect. For example for setup_data ranges

s/ for/,/

> will still be marked as normal system ram, thus when later sysfs driver
> ioremap them kernel will warn about mapping normal ram.
> 
> This patch fix it by moving the e820_reserve_setup_data callback after
> parsing early params so they can be set as reserved ranges and later
> ioremap will be fine with it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
