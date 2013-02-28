Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3B1IzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:55:21 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:38042 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3B1IzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:55:19 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com>
Date: Thu, 28 Feb 2013 08:57:33 +0100
In-Reply-To: <20130226033156.GA24999@kroah.com> (Greg KH's message of "Mon, 25
	Feb 2013 19:31:56 -0800")
Message-ID: <8738wgsweq.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH:

> On Tue, Feb 26, 2013 at 03:13:38AM +0000, Matthew Garrett wrote:
>> Because Microsoft have indicated that they'd be taking a reactive 
>> approach to blacklisting and because, so far, nobody has decided to 
>> write the trivial proof of concept that demonstrates the problem.
>
> So, once that proof is written, suddenly all of the working Linux
> distros's keys will be revoked?

The counterargument to that is that Microsoft will not proactively
revoke UEFI drivers, only drivers which are actually abused.

As far as I know, there is no public commitment to this revocation
policy.  It makes sense, given the limited revocation space, but
that's all.

> I don't buy it.  Yes, I understand this is your position, and has been
> all along, and _maybe_ you can extend it to "we should sign our kernel
> modules", but to take it farther than that, like the list David has
> described, is not required by anyone here.

It's a logical extrapolation based on the technical specification.
I've been guilty of the same mistake, if you want to call it that way.
Basically, we're making up concrete security objectives because the
existing documentation doesn't provide them, and write our code
according to that.  But we can easily guess wrong, in both directions.

In any case, there's another reading of the UEFI Secure Boot
requirements: you may run any code you wish after calling
ExitBootServices().  That could be an unsigned, traditional GRUB.  But
this will not generally address the issue of dual-booting Windows 8 in
such a way that Windows sees that the device has enabled Microsoft
Secure Boot.
