Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab3BZEFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:05:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39064 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3BZEFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:05:01 -0500
Date: Tue, 26 Feb 2013 04:04:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226040456.GA30717@srcf.ucam.org>
References: <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226035416.GA1128@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 07:54:16PM -0800, Greg KH wrote:
> On Tue, Feb 26, 2013 at 03:38:04AM +0000, Matthew Garrett wrote:
> > On Mon, Feb 25, 2013 at 07:31:56PM -0800, Greg KH wrote:
> > > So, once that proof is written, suddenly all of the working Linux
> > > distros's keys will be revoked?  That will be fun to watch happen, and
> > > odds are, it will not.  Imagine the PR fun that will cause :)
> > 
> > No. Why would they be?
> 
> Because they are using the "public" shim that you provided them, or the
> Linux Foundation's shim.  Almost no distro, other than the "main" 3-4
> will end up getting their own shim signed, the rest will just use the
> one you so helpfully provided them :)

There's no reason for the LF or generic shim to be blacklisted, since 
neither will load anything without manual intervention. But that also 
means that anyone trying to boot them has to have some knowledge of 
English, and that there's no way to netboot them. But sure, anyone 
planning that approach has much less to worry about.

> > > I don't buy it.  Yes, I understand this is your position, and has been
> > > all along, and _maybe_ you can extend it to "we should sign our kernel
> > > modules", but to take it farther than that, like the list David has
> > > described, is not required by anyone here.
> > 
> > Failing to take it to that extent is dangerously naive. If you can do it 
> > with kernel modules, you can do it with kexec. If you can do it with 
> > kexec, you can do it with arbitrary mmio access to PCI devices.
> 
> Yes you can.  There are all sorts of fun ways you can do this, I can
> think of a few more at the moment as well.  So, where does it stop?
> And why stop it at all?  Why not just forbid root users at all?

Because there's a distinction between ring 0 and ring 3?

> > Microsoft aren't dictating anything here. We're free not to use their 
> > signatures. However, if we do use their signatures, we agree to play by 
> > their rules. Nobody seems to have come up with a viable alternative, so 
> > here we are.
> 
> Ok, I keep hearing people say, "why doesn't someone else create a
> signing authority!" all the time.  And it comes down to one big thing,
> money.

Right. We've failed at creating an alternative. That doesn't mean that 
we get to skip the responsibilities associated with the choice we've 
made.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
