Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaAOLqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:46:32 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:39607 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaAOLqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:46:30 -0500
Date: Wed, 15 Jan 2014 11:47:00 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Patch Tracking <patches@linaro.org>, Mark Salter <msalter@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Subject: Re: [PATCH V6 6/8] Add EFI stub for ARM
Message-ID: <20140115114700.GI30907@bivouac.eciton.net>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
 <1389371417-379-7-git-send-email-roy.franz@linaro.org>
 <CAKv+Gu9OfieNhvj07tQv+ucQomZhDVDxwdV3Z9Tm+HaHE8HG-Q@mail.gmail.com>
 <CAFECyb9jx4NA0v_qNgrto4qG3KV3fBOpGh839Mnvbjody4xwYA@mail.gmail.com>
 <CAFECyb9jbVHjM7--tRgbjfS9_MaAAvOhR3qXEKPKS6eW23V9Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb9jbVHjM7--tRgbjfS9_MaAAvOhR3qXEKPKS6eW23V9Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 06:16:58PM -0800, Roy Franz wrote:
> >>> +      .align 3
> >>> +pe_header:
> >>> +       .ascii  "PE"
> >>> +       .short  0
> >>> +
> >>> +coff_header:
> >>> +       .short  0x01c2                          @ ARM or Thumb
> >>
> >> Could you explain why you are using 0x1c2 (Thumb) here and not 0x1c0 (ARM) ?
> >
> > Nope.  It should be 0x1c0.
> 
> OK, now I resolved the nagging feeling that I had already fixed
> this...   Right now, the EDK2 UEFI implementation
> requires the machine type for ARM to be "0x1c2".  I don't think that
> this is correct, but correcting this in EDK2 slipped through
> the cracks, but is now back on my todo list.

Nope, it should be 0x1c2.

0x1c0 is the COFF code for ARM only, which corresponds roughly with
OABI - which is not supported (and never will be) by the UEFI
specification.
0x1c2 means ARM or Thumb (Interworking), which is what we have.

The UEFI specification (correctly) neglects to even mention 0x1c0
and 0x1c4.

Do also note that the COFF information relates to the executable,
the stub. The rest of the kernel image is just a blob as far as UEFI
is concerned.

> I think that for now we should leave this as 0x1c2 so that the
> unpatched EDK2 builds will boot it, and some time after EDK2 is
> updated
> this can be changed.  I'll work on a patch for EDK2 and get the
> discussion going on that list to resolve this in EDK2.

No need.

/
    Leif
