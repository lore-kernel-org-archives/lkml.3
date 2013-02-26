Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab3BZDyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:54:23 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50166 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352Ab3BZDyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:54:20 -0500
Date: Mon, 25 Feb 2013 19:54:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226035416.GA1128@kroah.com>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130226033803.GA30285@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 03:38:04AM +0000, Matthew Garrett wrote:
> On Mon, Feb 25, 2013 at 07:31:56PM -0800, Greg KH wrote:
> > On Tue, Feb 26, 2013 at 03:13:38AM +0000, Matthew Garrett wrote:
> > > Because Microsoft have indicated that they'd be taking a reactive 
> > > approach to blacklisting and because, so far, nobody has decided to 
> > > write the trivial proof of concept that demonstrates the problem.
> > 
> > So, once that proof is written, suddenly all of the working Linux
> > distros's keys will be revoked?  That will be fun to watch happen, and
> > odds are, it will not.  Imagine the PR fun that will cause :)
> 
> No. Why would they be?

Because they are using the "public" shim that you provided them, or the
Linux Foundation's shim.  Almost no distro, other than the "main" 3-4
will end up getting their own shim signed, the rest will just use the
one you so helpfully provided them :)

> > > "In addition, in the case of Microsoft’s digital signatures of UEFI 
> > > Code, Microsoft may remove a Compatible Product from the Microsoft 
> > > Compatibility Lists and/or revoke the digital signature upon 30 days’ 
> > > notice to Company in the event Microsoft determines in its sole judgment 
> > > that the security of the UEFI Code is compromised."
> > > 
> > > The ability to use the signed code to boot an untrusted copy of the 
> > > Windows kernel is a clear breach of the trust model.
> > 
> > I don't buy it.  Yes, I understand this is your position, and has been
> > all along, and _maybe_ you can extend it to "we should sign our kernel
> > modules", but to take it farther than that, like the list David has
> > described, is not required by anyone here.
> 
> Failing to take it to that extent is dangerously naive. If you can do it 
> with kernel modules, you can do it with kexec. If you can do it with 
> kexec, you can do it with arbitrary mmio access to PCI devices.

Yes you can.  There are all sorts of fun ways you can do this, I can
think of a few more at the moment as well.  So, where does it stop?
And why stop it at all?  Why not just forbid root users at all?

> > Yes, they are all "nice" things to have, but I fail to see how Microsoft
> > should be dictating how Linux, or any other operating system, works,
> > especially when they aren't even signing the kernel, they are merely
> > signing a bootloader shim and saying "do your best for keeping the rest
> > of the system secure please."
> 
> Microsoft aren't dictating anything here. We're free not to use their 
> signatures. However, if we do use their signatures, we agree to play by 
> their rules. Nobody seems to have come up with a viable alternative, so 
> here we are.

Ok, I keep hearing people say, "why doesn't someone else create a
signing authority!" all the time.  And it comes down to one big thing,
money.

The money required to put up a bond to allow a root key to be placed
into the BIOS for just one major OEM is larger than pretty much all of
the Linux companies combined at this moment in time.

The money required to staff up, and put into place the proper
infrastructure to be a signing authority is, I'm pretty sure, larger
than the operating budget of the Linux Foundation at this point in time.
And again, remember the bond requirement of the OEMs.

So that's why the LF, or anyone else, including the UEFI group
themselves, are NOT getting into the key signing business.  Money.

Oh, and the fact that it's just not worth it in the end, but that's a
different topic :)

thanks,

greg k-h
