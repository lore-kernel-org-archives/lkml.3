Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3LBDAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 22:00:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3LBDAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 22:00:41 -0500
Date: Mon, 2 Dec 2013 10:59:42 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131202025942.GF3999@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
 <20131129115029.GB4266@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129115029.GB4266@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/13 at 12:50pm, Borislav Petkov wrote:
> No need for the list - I actually meant you simply use a tmp pointer for
> each krealloc invocation - just look around the tree for examples.
> 
> Also think about what happens to the pointed-to memory when krealloc
> returns NULL.

Ok, thanks for the explaination.

> 
> > suppose kexec runtime map preparing fails we still can get 1st kernel
> > boot ok.
> 
> Yeah, nothing stops that - especially if you iterate over the mapped
> regions a second time separately, for kexec.
> 
> Which reminds me, all that save_runtime_map code needs to be behind
> CONFIG_KEXEC. We don't want to be doing this if KEXEC is not enabled.

They are only called if there's setup_data SETUP_EFI passed in. Yes, I think
only kexec need that part of code. But I hesitated to mess the code with
a lot of #if. Will think about it.

Thanks
Dave
