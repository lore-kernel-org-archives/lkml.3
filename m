Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3K2Jpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:45:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab3K2JpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:45:08 -0500
Date: Fri, 29 Nov 2013 17:44:19 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 10/12] x86: export x86 boot_params to sysfs
Message-ID: <20131129094419.GJ4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-11-git-send-email-dyoung@redhat.com>
 <20131127112022.GE18170@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127112022.GE18170@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13 at 11:20am, Matt Fleming wrote:
> On Tue, 26 Nov, at 01:57:55PM, Dave Young wrote:
> > +Users:
> > +		Kexec Mailing List <kexec@lists.infradead.org>
> 
> "Kexec" please.

Will change

> 
> > +static ssize_t version_show(struct kobject *kobj,
> > +					struct kobj_attribute *attr, char *buf)
> 
> This is pretty strange indentation. Usually we prefer to line up the
> arguments like you've done elsewhere in this file.

Ok.

> 
> > +{
> > +	return sprintf(buf, "0x%04x\n", boot_params.hdr.version);
> > +}
> > +
> > +static struct kobj_attribute boot_params_version_attr = __ATTR_RO(version);
> > +
> > +static ssize_t boot_params_data_read(struct file *fp, struct kobject *kobj,
> > +				     struct bin_attribute *bin_attr,
> > +				     char *buf, loff_t off, size_t count)
> > +{
> > +	memcpy(buf, (void *)&boot_params + off, count);
> > +	return count;
> > +}
> 
> Don't we need some checks here to ensure we don't read past the end of
> boot_params?

The size was added below, so I would assume file read will not beyond the
file size:
.size = sizeof(boot_params),

> 
> > +static ssize_t type_show(struct kobject *kobj,
> > +					struct kobj_attribute *attr, char *buf)
> 
> More whacky indentation.

Will fix

> 
> > +static int __init create_setup_data_node(struct kobject *parent,
> > +					struct kobject **kobjp, int nr)
> 
> Funky indentation.

Will fix

Thanks for review
Dave
