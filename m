Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3LLUx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:53:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57817 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab3LLUxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:53:55 -0500
Date: Thu, 12 Dec 2013 21:53:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131212205346.GA30162@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
 <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:36:17AM +0800, Dave Young wrote:
> Sorry that I forgot to explain this in changelog, should ask you before.
> 
> I did try moving it to efisubsys_init but it need add extern declaration

So what? Add it.

> for efi_runtime_map_init. Since link order will ensure it being called after
> efisubsys_init I think it's fine with this static function.

This is actually exactly the reason why it shouldn't be another
subsys_initcall() if it can be helped. People would need to go have a
look at drivers/firmware/efi/Makefile to realize that the link order is
ok.

And, this is prone to future breakage if people go and move code around
and thereby change the link order.

Please call efi_runtime_map_init from efisubsys_init.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
