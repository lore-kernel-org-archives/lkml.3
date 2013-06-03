Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab3FCO10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:27:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42896 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758040Ab3FCO1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:27:25 -0400
Message-ID: <1370269642.2910.4.camel@dabdike>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Date: Mon, 03 Jun 2013 07:27:22 -0700
In-Reply-To: <20130603081148.GB13607@nazgul.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
	 <20130602225620.GA5496@srcf.ucam.org> <20130603081148.GB13607@nazgul.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 10:11 +0200, Borislav Petkov wrote:
> On Sun, Jun 02, 2013 at 11:56:20PM +0100, Matthew Garrett wrote:
> > I've just run Windows 8 under a hacked up copy of OVMF that dumps
> > the data passed to SetVirtualAddressMap. It seems that Windows *is*
> > mapping the runtime services to higher addresses - so presumably the
> > 1:1 mapping is in addition to the virtual mapping.
> 
> But but, once we call SetVirtualAddressMap with the set of addresses of
> the runtime services, only those can be used after, right? If so, we
> can't have both (this is at least my understanding)...

That's correct.  I think not calling SetVirtualAddressMap() and just
using a 1:1 mapping is far safer (having looked at what tianocore does
for SetVirtualAddressMap()).  The chances are that all the UEFI bioses
are only tested with windows, so the pointer chases it has to do to
switch address maps only work with the operations windows does.

James


