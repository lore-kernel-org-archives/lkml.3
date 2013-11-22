Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3KVDXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:23:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab3KVDXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:23:32 -0500
Date: Fri, 22 Nov 2013 10:45:06 +0800
From: Dave Young <dyoung@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 9/9 v3] x86: export x86 boot_params to sysfs
Message-ID: <20131122024506.GB3874@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061757.030007746@dhcp-16-126.nay.redhat.com>
 <20131121164554.GB15083@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121164554.GB15083@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/13 at 08:45am, Greg KH wrote:
> > +static struct kobj_attribute boot_params_version_attr =
> > +	__ATTR(version, S_IRUGO, boot_params_version_show, NULL);
> 
> __ATTR_RO() please.

Will do

> 
> > +static struct kobj_attribute type_attr =
> > +		__ATTR(type, S_IRUGO, setup_data_type_show, NULL);
> 
> __ATTR_RO() here too.

Will do

[snip]
> > +
> > +	ret = get_setup_data_size(nr, &size);
> > +	if (ret)
> > +		goto out_kobj;
> > +
> > +	data_attr.size = size;
> > +	ret = sysfs_create_bin_file(kobj, &data_attr);
> > +	if (ret)
> > +		goto out_file;
> > +	*kobjp = kobj;
> 
> You just raced with userspace (creating and announcing the kobject and
> then, afterward, at some later point in time, created the sysfs files.
> Please use the groups option to create the files properly before
> announcing the kobject to userspace.

Will do

[snip]
> > +		goto out_boot_params_kobj;
> > +	ret = sysfs_create_bin_file(boot_params_kobj,
> > +				      &boot_params_data_attr);
> > +	if (ret)
> > +		goto out_create_file;
> > +
> > +	ret = create_setup_data_nodes(boot_params_kobj);
> > +	if (ret)
> > +		goto out_create_bin;
> > +
> > +	return 0;
> 
> Same race condition here as well.  Use a groups structure please.
> 

Will use group attributes

Thanks for review
Dave
