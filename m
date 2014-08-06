Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbaHFOsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:48:46 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58972 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaHFOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:48:44 -0400
Date: Wed, 6 Aug 2014 15:48:39 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140806144839.GK4179@bivouac.eciton.net>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
 <20140806132941.GJ4179@bivouac.eciton.net>
 <20140806140155.GC15082@console-pimps.org>
 <CAKv+Gu8ey1iKu-_wS6yYaEXQaQMDXa+PF5Kiw+edA9a_OE1EAw@mail.gmail.com>
 <20140806141814.GD15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806141814.GD15082@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 03:18:14PM +0100, Matt Fleming wrote:
> On Wed, 06 Aug, at 04:10:45PM, Ard Biesheuvel wrote:
> > 
> > Shouldn't we clear the bit here if we failed to enable runtime
> > services for some reason? Other code may test the bit assuming that it
> > signifies that runtime services have been enabled successfully, while
> > this patch changes it to mean that we /intended/ to enable them, which
> > is not quite the same thing.
> 
> Yep, good catch. We need to do something similar for efi_runtime_init()
> on x86 too.

Since we're now overlaying two different meanings onto the
EFI_RUNTIME_SERVICES bit, could we add comments at set/clear points to
explicitly state the intended action? I.e.:

/* Set to attempt runtime services initialisation */

/* Clear to indicate runtime services will not be available */

/
    Leif
