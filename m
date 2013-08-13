Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab3HMTCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:02:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58271 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757259Ab3HMTCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:02:09 -0400
Message-ID: <1376420525.3467.70.camel@dabdike.int.hansenpartnership.com>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Date: Tue, 13 Aug 2013 12:02:05 -0700
In-Reply-To: <520A8054.1030108@zytor.com>
References: <52050985.9070107@zytor.com>
	  <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>
	  <52050D03.4030805@zytor.com> <520A7B48.3020304@zytor.com>
	 <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
	 <520A8054.1030108@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 11:52 -0700, H. Peter Anvin wrote:
> On 08/13/2013 11:43 AM, James Bottomley wrote:
> > Can we actually boot a 32 bit kernel on an EFI64 system?  The last time
> > I tried on my Secure Boot SDV it wouldn't work; the problem is getting
> > someting in the transfer of control path to boot the processor back to
> > 32 bit mode.
> 
> We can boot with a bootloader in "skip stub" mode; no runtime services
> yet.

So the bootloader has to do the 64->32 transition?

>   We are working on making it possible to boot via a EFI stub in
> assisted mode (still needing a bootloader, but with the boot stub in the
> kernel.)
> 
> Runtime services will be the last piece, obviously, but even that looks
> reasonably doable.

So why not start with the working case (default to EFI on 64 bit) and
add in the mostly non-working case (default to EFI on 32 bit) when it
actually mostly works?

James


