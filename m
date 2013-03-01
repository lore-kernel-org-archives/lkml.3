Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3CAAIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:08:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3CAAIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:08:16 -0500
Date: Fri, 1 Mar 2013 01:08:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
In-Reply-To: <20130301000020.GA13796@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1303010105491.11745@pobox.suse.cz>
References: <30665.1361461678@warthog.procyon.org.uk> <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz> <20130228225115.GA12360@srcf.ucam.org> <alpine.LNX.2.00.1302282357210.11745@pobox.suse.cz> <20130228230518.GA12717@srcf.ucam.org>
 <alpine.LNX.2.00.1303010040280.11745@pobox.suse.cz> <20130228234743.GA13709@srcf.ucam.org> <alpine.LNX.2.00.1303010049490.11745@pobox.suse.cz> <20130301000020.GA13796@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013, Matthew Garrett wrote:

> > > If you've loaded an x.509 certificate into the kernel and it's later 
> > > revoked, any module signed with the key is going to be loadable until 
> > > it's revoked. I don't see an especially large difference here?
> > 
> > i_own_your_ring0.ko can be modprobed long after blacklisting of "hello 
> > world" binary hash has happened on the very particular machine in its dbx 
> > (as there is no link, in a x509-chain-of-trust-sense, between the hash of 
> > the PE binary and the i_own_your_ring0.ko signature key).
> 
> Ah, I see what you mean. Yes, we should probably keep track of the 
> linkage between the original hash and the key in the kernel and then 
> invalidate the key if a corresponding dbx update is pushed, 

That will at least make the blacklisting work properly, yes.

It of course still doesn't fix the principal problem, that you are 
artificially changing the signature semantics of "Microsoft trusts this 
binary" to "we claim that Microsoft actually meant that they trust this 
key".
That has very little to do with proper X509 cryptography.

But at least we are on a same page now.

Thanks,

-- 
Jiri Kosina
SUSE Labs
