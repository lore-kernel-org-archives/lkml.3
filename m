Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3B1Xwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:52:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab3B1Xwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:52:53 -0500
Date: Fri, 1 Mar 2013 00:52:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
In-Reply-To: <20130228234743.GA13709@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1303010049490.11745@pobox.suse.cz>
References: <30665.1361461678@warthog.procyon.org.uk> <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz> <20130228225115.GA12360@srcf.ucam.org> <alpine.LNX.2.00.1302282357210.11745@pobox.suse.cz> <20130228230518.GA12717@srcf.ucam.org>
 <alpine.LNX.2.00.1303010040280.11745@pobox.suse.cz> <20130228234743.GA13709@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013, Matthew Garrett wrote:

> > > Sure, if you've been infected before the revocation, you'll still be 
> > > infected. There's not really any good way around that.
> > 
> > Which is a very substantial difference to normal X509 chain of trust, 
> > isn't it?
> 
> If you've loaded an x.509 certificate into the kernel and it's later 
> revoked, any module signed with the key is going to be loadable until 
> it's revoked. I don't see an especially large difference here?

i_own_your_ring0.ko can be modprobed long after blacklisting of "hello 
world" binary hash has happened on the very particular machine in its dbx 
(as there is no link, in a x509-chain-of-trust-sense, between the hash of 
the PE binary and the i_own_your_ring0.ko signature key).

modprobe of a module signed by a key that has been blacklisted on the very 
particular machine in its dbx is not going to work (as there is a very 
direct x509 chain of trust link).

No?

Thanks,

-- 
Jiri Kosina
SUSE Labs
