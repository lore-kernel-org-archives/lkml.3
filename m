Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3KZJN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:13:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3KZJNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:13:55 -0500
Date: Tue, 26 Nov 2013 17:13:01 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 05/12] efi: export more efi table variable to sysfs
Message-ID: <20131126091301.GB10899@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-6-git-send-email-dyoung@redhat.com>
 <20131126085035.GC20917@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126085035.GC20917@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/13 at 09:50am, Borislav Petkov wrote:
> On Tue, Nov 26, 2013 at 01:57:50PM +0800, Dave Young wrote:
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index 2e2fbde..5d85956 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
> >  	.hcdp       = EFI_INVALID_TABLE_ADDR,
> >  	.uga        = EFI_INVALID_TABLE_ADDR,
> >  	.uv_systab  = EFI_INVALID_TABLE_ADDR,
> > +	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
> > +	.runtime    = EFI_INVALID_TABLE_ADDR,
> > +	.config_table  = EFI_INVALID_TABLE_ADDR,
> 
> See what I mean with alignment?

Yes, I see. As for this segment I would not like change the previous code
just because of this reason

> 
> Now this config_table thing sticks out and completely destroys the
> balance in the universe.
> 
> :-)
> 
> >  };
> >  EXPORT_SYMBOL(efi);
> >  
> > @@ -71,13 +74,54 @@ static ssize_t systab_show(struct kobject *kobj,
> >  static struct kobj_attribute efi_attr_systab =
> >  			__ATTR(systab, 0400, systab_show, NULL);
> >  
> > +static ssize_t fw_vendor_show(struct kobject *kobj,
> > +				struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "0x%lx\n", efi.fw_vendor);
> > +}
> > +
> > +static ssize_t runtime_show(struct kobject *kobj,
> > +				struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "0x%lx\n", efi.runtime);
> > +}
> > +
> > +static ssize_t config_table_show(struct kobject *kobj,
> > +				struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "0x%lx\n", efi.config_table);
> > +}
> 
> Those are sooo similar, it's like the macro SHOW writes itself.

Ok, will add a macro for the above functions..

Thanks for review
Dave
