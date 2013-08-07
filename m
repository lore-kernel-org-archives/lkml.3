Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3HGLzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:55:04 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:54794 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab3HGLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:55:01 -0400
Date: Wed, 7 Aug 2013 13:54:58 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com,
        tony.luck@gmail.com, patches@linaro.org
Subject: Re: [PATCH v2 2/5] efi: provide a generic efi_config_init()
Message-ID: <20130807115458.GM18151@rocoto.smurfnet.nu>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
 <1375462582-16423-3-git-send-email-leif.lindholm@linaro.org>
 <20130805121540.GP2515@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805121540.GP2515@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 01:15:40PM +0100, Matt Fleming wrote:
> > +static __init int match_config_table(efi_guid_t *guid,
> > +				     unsigned long table,
> > +				     efi_config_table_type_t *table_types)
> > +{
> > +	u8 str[38];
> 
> Shouldn't this be 37? You get 36 bytes for your GUID, plus a trailing
> NUL? Either way, this should be a #define. The closest thing we have in
> include/linux/efi.h is EFI_VARIABLE_GUID_LEN. Perhaps we need a
> EFI_GUID_LEN that includes the trailing NUL?
 
Err, yes. Don't recall where I decided on that now.
I think EFI_VARIABLE_GUID_LEN + 1 makes enough sense.

> One thing I just noticed that's worth pointing out is that 'pr_fmt'
> isn't defined in drivers/firmware/efi/efi.c. Before your patch series
> you get,
> 
> [    0.000000] efi:  SMBIOS=0xbae41a98  ACPI=0xbac6f000  ACPI 2.0=0xbac6f000  MPS=0xfca90 
> 
> and after,
> 
> [    0.000000]  SMBIOS=0xbae41a98  ACPI=0xbac6f000  ACPI 2.0=0xbac6f000 MPS=0xfca90 
> 
> which isn't the end of the world, but it does mean that the error
> messages are now much less informative, e.g.
 
I had completely missed that - sorry.
Adding in new series.

/
    Leif
