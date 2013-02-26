Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3BZDNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:13:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38285 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3BZDNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:13:44 -0500
Date: Tue, 26 Feb 2013 03:13:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226031338.GA29784@srcf.ucam.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130226030249.GB23834@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 07:02:49PM -0800, Greg KH wrote:
> On Tue, Feb 26, 2013 at 02:33:32AM +0000, Matthew Garrett wrote:
> > Oh, come on Greg. Allowing unsigned modules allows loading arbitrary 
> > code into the kernel, and allowing arbitrary code into the kernel means 
> > that the kernel can be used to directly boot a modified copy of the 
> > Windows kernel. Avoiding that scenario is *explicitly* mandated by 
> > Microsoft.
> 
> Then why is the signed shim is currently being used by successfully by
> distros that do not use signed kernel modules?

Because Microsoft have indicated that they'd be taking a reactive 
approach to blacklisting and because, so far, nobody has decided to 
write the trivial proof of concept that demonstrates the problem.

> > We can avoid it by either not using Microsoft as the root of 
> > trust or by requiring explicit key installation during the OS install 
> > process, but both of those make OS installation more difficult. If we 
> > want Linux to Just Work out of the box on Microsoft-certified hardware, 
> > this is one of the rules we have to live by.
> 
> I don't see that being required in the wording for the Microsoft signing
> authority, and in personal discussions with them, they say it would be
> nice, but they can't force the issue.  Where does it say this in the
> agreement specifically?

"In addition, in the case of Microsoft’s digital signatures of UEFI 
Code, Microsoft may remove a Compatible Product from the Microsoft 
Compatibility Lists and/or revoke the digital signature upon 30 days’ 
notice to Company in the event Microsoft determines in its sole judgment 
that the security of the UEFI Code is compromised."

The ability to use the signed code to boot an untrusted copy of the 
Windows kernel is a clear breach of the trust model.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
