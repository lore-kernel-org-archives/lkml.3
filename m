Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3LPQfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:35:09 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:41450 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab3LPQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:35:07 -0500
Date: Mon, 16 Dec 2013 16:35:01 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v6 14/14] x86: kdebugfs do not use __va for getting
 setup_data virt addr
Message-ID: <20131216163501.GB3873@console-pimps.org>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-15-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387186235-15972-15-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec, at 05:30:35PM, Dave Young wrote:
> kdump kernel will use memmap=exactmap kernel cmdline, but __va does not
> work in case memmap=exactmap, so let's always use ioremap_cache.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/kernel/kdebugfs.c | 35 +++++++++++------------------------
>  1 file changed, 11 insertions(+), 24 deletions(-)

Dave, I've no idea why this change is necessary from the commit log. Is
it required for kexec to function on EFI? Why does __va() not work in
the memmap=exactmap case?

-- 
Matt Fleming, Intel Open Source Technology Center
