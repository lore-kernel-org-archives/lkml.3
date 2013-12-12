Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3LLHOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:14:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3LLHOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:14:32 -0500
Date: Thu, 12 Dec 2013 15:13:37 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131212071337.GI3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
 <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > 
> > and the EFI_BOOT* tests can be done in save_runtime_map and also the
> > error handling can happen there. This way efi_map_regions() won't
> > need to know about anything. This way, you can later move the whole
> > save_runtime_map() function to efi-kexec.c just by taking it without any
> > need for untangling.
> > 
> > > +out_save_runtime:
> > > +       kfree(efi_runtime_map);
> > > +       nr_efi_runtime_map = 0;
> > > +       efi_runtime_map = NULL;
> > 
> > This can go there too.
> 
> This section can go the save_runtime_map but it looks clearer to put them here.

BTW, I will restructure the whole code when I move them to efi_kexec.c,
so no worry about it? If you have strong opinion I can move them though.

Thanks
Dave
