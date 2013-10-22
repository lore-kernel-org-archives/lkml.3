Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3JVPgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3JVPgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:36:03 -0400
Date: Tue, 22 Oct 2013 11:35:44 -0400
From: Peter Jones <pjones@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        grub-devel@gnu.org, david.woodhouse@intel.com,
        richard.l.maliszewski@intel.com, xen-devel@lists.xen.org,
        boris.ostrovsky@oracle.com, Daniel Kiper <daniel.kiper@oracle.com>,
        linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022153543.GB16271@fenchurch.internal.datastacks.com>
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <20131022140947.GA17829@phenom.dumpdata.com>
 <1382451868.18283.21.camel@hastur.hellion.org.uk>
 <20131022145140.GA18679@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131022145140.GA18679@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:51:40AM -0400, Konrad Rzeszutek Wilk wrote:
> And I still haven't found the module that can launch any PE/COFF
> image from GRUB2. Maybe that is a myth.

"chainload" will do this.  In fact, it doesn't do much:

static grub_err_t
grub_chainloader_boot (void)
{
  grub_efi_boot_services_t *b;
  grub_efi_status_t status;
  grub_efi_uintn_t exit_data_size;
  grub_efi_char16_t *exit_data = NULL;

  b = grub_efi_system_table->boot_services;
  status = efi_call_3 (b->start_image, image_handle, &exit_data_size, &exit_data);
  if (status != GRUB_EFI_SUCCESS)
    ...

That means, of course, that it won't use shim on Secure Boot systems.

There's probably some value in merging the two, so that chainload will
use the efi stub if and only if a) it's present, and b) it's needed for
e.g. multiple initrds or bad UGA/GOP data.

-- 
        Peter
