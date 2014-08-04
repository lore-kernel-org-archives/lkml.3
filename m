Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaHDM1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:27:34 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41671 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaHDM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:27:33 -0400
Date: Mon, 4 Aug 2014 13:27:28 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140804122728.GH15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140804113435.34ed8c76@pluto>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug, at 11:34:35AM, Bruno Prémont wrote:
> Hi,
> 
> Since 3.13 kernels with built-in initrd fail to boot on Fujitsu hardware
> in EFI mode (efi stub) though the exact same kernel binary does boot in
> BIOS mode (grub).
> Interestingly EFI kernels with different config do boot under VMWare.
> 
> Your patch "initramfs: read CONFIG_RD_ variables for initramfs
> compression" is the trigger.
> 
> 
> Is something missing in EFI stub or why do things behave differently?
 
Nuts. I suspect it's an EFI boot stub bug. Have you definitely tried out
3.16? In particular the following commit might make a difference,

  commit c7fb93ec51d4
  Author: Michael Brown <mbrown@fensystems.co.uk>
  Date:   Thu Jul 10 12:26:20 2014 +0100

      x86/efi: Include a .bss section within the PE/COFF headers
    
      The PE/COFF headers currently describe only the initialised-data
      portions of the image, and result in no space being allocated for the
      uninitialised-data portions.  Consequently, the EFI boot stub will end
      up overwriting unexpected areas of memory, with unpredictable results.
    
      Fix by including a .bss section in the PE/COFF headers (functionally
      equivalent to the init_size field in the bzImage header).
    
      Signed-off-by: Michael Brown <mbrown@fensystems.co.uk>
      Cc: Thomas Bächler <thomas@archlinux.org>
      Cc: Josh Boyer <jwboyer@fedoraproject.org>
      Cc: <stable@vger.kernel.org>
      Signed-off-by: Matt Fleming <matt.fleming@intel.com>


> Looking at compiled kernel with and without this patch the resulting
> bzImage is similar in size but in build directory I get:

Could you send me the initrd image? I'd like to try and reproduce this
on my end, even though I regularly boot with a built-in initrd.

-- 
Matt Fleming, Intel Open Source Technology Center
