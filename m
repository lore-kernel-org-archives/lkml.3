Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3FZOf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:35:28 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46666 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3FZOf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130626140459.GB9078@rocoto.smurfnet.nu>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com> <20130626140459.GB9078@rocoto.smurfnet.nu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 15:35:06 +0100
X-Google-Sender-Auth: kul4-l0M7Kk6yGUn5dVthGJziVI
Message-ID: <CACxGe6uJN1tLNYpb-_MiX5xMQnUsC84Wybe2estz_VST-A0P-w@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:04 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Wed, Jun 26, 2013 at 02:13:39PM +0100, Grant Likely wrote:
>> > +- 'efi-runtime-mmap':
>> > +  Physical address of an EFI memory map, containing at least
>> > +  the regions to be preserved. (required)
>> > +- 'efi-runtime-mmap-size':
>> > +  Size in bytes of the provided memory map. (required)
>>
>> I would collapse the above two properties into a single property that
>> actually contains the memory map instead of pointing to it. You will
>> also need to specify the exact format of the data in this property.
>
> Ok, that makes sense.
>
> Hmm. The data is an array of struct EFI_MEMORY_DESCRIPTOR entries,
> known in Linux as efi_memory_desc_t. Is that a good enough description?

Yes, it is perfectly valid to point at another spec and state "it is
in that format". You'll also want to be specific that the data is
using the UEFI byte ordering, and not the ordering normally used by
FDT. One could argue that it should be 'translated' into a native DT
data format, but I think it is better to view it as a BLOB that DT
doesn't have anything to say about.

>> > +- 'efi-mmap-desc-size':
>> > +  Size of each descriptor in the memory map. (override default)
>> > +- 'efi-mmap-desc-ver':
>> > +  Memory descriptor format version. (override default)
>>
>> I don't understand how these properties will actually work. What
>> changes in the parsing if these properties are set?
>
> I guess the intended use is that these options would permit you to
> append new fields to the struct and have old code correctly parse the
> array anyway.

Let's leave them out as part of the binding until it is actually needed.

g.
