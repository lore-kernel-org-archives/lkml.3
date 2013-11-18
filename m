Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3KRCRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3KRCRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:17:36 -0500
Date: Mon, 18 Nov 2013 10:16:41 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 5/7 v2] export efi runtime memory mapping to sysfs
Message-ID: <20131118021641.GC4025@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082718.185728964@dhcp-16-126.nay.redhat.com>
 <20131113155027.GC17248@console-pimps.org>
 <20131114015047.GD4081@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114015047.GD4081@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +/*
> > > + * These are default attributes that are added for every memmap entry.
> > > + */
> > > +static struct attribute *def_attrs[] = {
> > > +	&map_type_attr.attr,
> > > +	&map_phys_addr_attr.attr,
> > > +	&map_virt_addr_attr.attr,
> > > +	&map_num_pages_attr.attr,
> > > +	&map_attribute_attr.attr,
> > > +	NULL
> > > +};
> > 
> > If the UEFI spec ever releases an update for the memory descriptor
> > structure, and bumps 'memmap.desc_version', how are we going to signal
> > the incompatibility to legacy versions of kexec tools?
> 
> Hmm, that is a problem. I will consider to export memmap according to
> what firmware provided with extra desc_version instead of using attrs from kernel
> data structure efi_memory_desc_t
> 

Matt, desc_version is already in boot_params.efi_info, so kexec-tools can get
the version from there. I do not need to export it as another file.

I think for now we do not need worry much about the compatibility issue, do you
think I need add version checking in kexec-tools currently? like below?

if (desc_version != 1) /* current version is 1? */
	error out it is not supported

--
Thanks
Dave
