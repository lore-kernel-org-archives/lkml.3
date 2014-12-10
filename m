Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaLJKqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:46:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54973 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbaLJKqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:46:30 -0500
Date: Wed, 10 Dec 2014 11:46:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Laszlo Ersek <lersek@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Shorten efi regions output
Message-ID: <20141210104627.GA17053@pd.tnic>
References: <20141209095843.GA3990@pd.tnic>
 <20141210021741.GA3280@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141210021741.GA3280@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:17:41AM +0800, Dave Young wrote:
> I have same feeling with you, it is too long for most of people.
>
> Since the printk code are for EFI_DEBUG, they are around the #ifdef
> so I would like to see a kernel param like efi_debug=on, so only
> efi_debug is specified then these verbose messages are printed.
> Without the param kernel can print some basic infomation about the
> memory ranges.
>
> In arm64 code there's already a uefi_debug param it can be moved to
> general code so that there will be a goable switch.

Hmm, makes sense to me. Maybe we should really hide those behind a
debug switch, the question is whether asking the user to boot with
"efi_debug=on" in order to see the regions is ok. And I think it is ok
because we do that when debugging other stuff so I don't see anything
different here.

And then when they're disabled by default, we don't really need to
shorten them as they're pure debug output then.

Matt?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
