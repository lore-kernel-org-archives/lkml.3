Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3LWCH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 21:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab3LWCHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 21:07:55 -0500
Date: Mon, 23 Dec 2013 10:06:48 +0800
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
Message-ID: <20131223020648.GA3760@dhcp-16-126.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
 <20131221145348.GC29501@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131221145348.GC29501@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		if (data)
> > +			early_memunmap(data, sizeof(*data));
> >  #ifdef CONFIG_X86_32
> >  		if (tmp >> 32) {
> >  			pr_err("EFI data located above 4GB, disabling EFI.\n");
> 
> This isn't correct, and means we now won't trigger this pr_err() if
> booting a CONFIG_X86_32 kernel with EFI_64BIT and where the ->fw_vendor,
> ->runtime or ->tables pointer is above 4GB - you've mixed up systab and
> systab64. I've fixed this up like so when applying this patch,

You are right, I missed this 32bit tmp value, thanks for taking care of this.

Thanks
Dave
