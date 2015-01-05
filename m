Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbbAEODh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:03:37 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53156 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbbAEODf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:03:35 -0500
Date: Mon, 5 Jan 2015 14:03:32 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>, linux-efi <linux-efi@vger.kernel.org>,
        Laszlo Ersek <lersek@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Shorten efi regions output
Message-ID: <20150105140332.GB3163@console-pimps.org>
References: <20141209095843.GA3990@pd.tnic>
 <20141210021741.GA3280@darkstar.nay.redhat.com>
 <20141210104627.GA17053@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210104627.GA17053@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec, at 11:46:28AM, Borislav Petkov wrote:
> On Wed, Dec 10, 2014 at 10:17:41AM +0800, Dave Young wrote:
> > I have same feeling with you, it is too long for most of people.
> >
> > Since the printk code are for EFI_DEBUG, they are around the #ifdef
> > so I would like to see a kernel param like efi_debug=on, so only
> > efi_debug is specified then these verbose messages are printed.
> > Without the param kernel can print some basic infomation about the
> > memory ranges.
> >
> > In arm64 code there's already a uefi_debug param it can be moved to
> > general code so that there will be a goable switch.
> 
> Hmm, makes sense to me. Maybe we should really hide those behind a
> debug switch, the question is whether asking the user to boot with
> "efi_debug=on" in order to see the regions is ok. And I think it is ok
> because we do that when debugging other stuff so I don't see anything
> different here.
> 
> And then when they're disabled by default, we don't really need to
> shorten them as they're pure debug output then.
> 
> Matt?

I'm fine with disabling the EFI memory output regions by default.

Printing the regions is still useful for debugging, but like you
mention, we frequently ask users to enable other debug options when
tracking down issues.

Laszlo, would you be OK with that?

-- 
Matt Fleming, Intel Open Source Technology Center
