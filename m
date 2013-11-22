Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3KVCwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:52:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab3KVCwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:52:37 -0500
Date: Fri, 22 Nov 2013 10:51:40 +0800
From: Dave Young <dyoung@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 5/9 v3] efi: export more efi table variable to sysfs
Message-ID: <20131122025140.GD3874@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
 <20131121164224.GA15083@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121164224.GA15083@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +	if (efi.config_table != EFI_INVALID_TABLE_ADDR) {
> > +		error = sysfs_create_file(efi_kobj,
> > +					&efi_attr_config_table.attr);
> > +		if (error) {
> > +			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
> > +				efi_attr_config_table.attr.name, error);
> > +			goto err_remove_runtime;
> > +		}
> > +	}
> 
> You don't need to do this "if SOMETHING then create the file", just use
> the "is_visible" attribute in the group to do this as a callback to
> determine this when the group is registered.

I did not know the is_visible before, thanks for the hint, will use it

--
Thanks for review
Dave
