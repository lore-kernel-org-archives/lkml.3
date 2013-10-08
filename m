Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3JHJTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:19:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3JHJTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:19:11 -0400
Date: Tue, 8 Oct 2013 17:18:35 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20131008091834.GB23216@dhcp-16-126.nay.redhat.com>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
 <20130926031242.GA4487@dhcp-16-126.nay.redhat.com>
 <20130930201730.GD16383@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930201730.GD16383@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for reply late because I was in a long holiday...

On 09/30/13 at 10:17pm, Borislav Petkov wrote:
> On Thu, Sep 26, 2013 at 11:12:42AM +0800, Dave Young wrote:
> > If we choose this approach, can we save not only the efi_mapping, but
> > also the fields which will be converted to virt addr, like fw_vendor,
> > runtime, tables? During my test on a HP workstation, the config table
> > item (SMBIOS) also is converted to virt addr though spec only mention
> > fw_vendor/runtime/tables.
> 
> Btw, I was about to ask: how do you pass boot_params to the kexec
> kernel?

As Vivek mentioned, just kexec-tools will get the saved info from sysfs
or procfs, then it as a boot loader will prepare the linux boot setup
struct with these 1st efi values.

> 
> Because I'm looking into hpa's idea to pass an efi_mapping array of
> regions with setup_data but how does this get passed to the kexec'ed
> kernel? I see in your patches you have boot_params.saved_*** for the
> needed info but you're not writing to them anywhere. Is that why you've
> added them to the systab_show function so that userspace can parse it
> and build the boot_params thing?

Yes, I just printed them in systab_show, kexec-tools will parse it.

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
