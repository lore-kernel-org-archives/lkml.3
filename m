Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3B1Xp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:45:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab3B1Xp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:45:26 -0500
Date: Fri, 1 Mar 2013 00:45:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
In-Reply-To: <20130228230518.GA12717@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1303010040280.11745@pobox.suse.cz>
References: <30665.1361461678@warthog.procyon.org.uk> <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz> <20130228225115.GA12360@srcf.ucam.org> <alpine.LNX.2.00.1302282357210.11745@pobox.suse.cz> <20130228230518.GA12717@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013, Matthew Garrett wrote:

> > But the real harm is being done by the i_own_your_ring0.ko module, which 
> > can be modprobed on all the systems where the signed "hello world" binary 
> > has been keyctl-ed before it was blacklisted.
> 
> Sure, if you've been infected before the revocation, you'll still be 
> infected. There's not really any good way around that.

Which is a very substantial difference to normal X509 chain of trust, 
isn't it?

This security model seems to be quite seriously flawed to me (in a sense 
that it has nothing to do with chain of trust as mandated by X509 even 
though it tries to pretend the opposite)

And frankly, Linus' proposal at [1] doesn't really make it any better in 
principle, it just keeps the whole thing out of kernel.

[1] https://lkml.org/lkml/2013/2/21/228

> > In other words -- you blacklist the population of the key on systems by 
> > blakclisting the key-carrying binary, but the key remains trusted on 
> > whatever system the binary has been processed by keyctl before. Right?
> 
> You have to re-load it on every boot, it's not a permanent thing.

That unfortunately seems to be very weak security measure as well.

Thanks,

-- 
Jiri Kosina
SUSE Labs
