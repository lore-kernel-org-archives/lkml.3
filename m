Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3B1XCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:02:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab3B1XCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:02:45 -0500
Date: Fri, 1 Mar 2013 00:02:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
In-Reply-To: <20130228225115.GA12360@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1302282357210.11745@pobox.suse.cz>
References: <30665.1361461678@warthog.procyon.org.uk> <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz> <20130228225115.GA12360@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013, Matthew Garrett wrote:

> > Let me formulate my point more clearly -- Microsoft very likely going to 
> > sign hello world EFI PE binary, no matter the contents of .keylist 
> > section, as they don't give a damn about this section, as it has zero 
> > semantic value to them, right?
> > 
> > They sign the binary. By signing the binary, they are *NOT* establishing 
> > cryptographic chain of trust to the key stored in .keylist, but your 
> > patchset seems to imply so.
> 
> Mr Evil Blackhat's binary is then a mechanism for circumventing the 
> Windows trust mechanism, 

Yes, the "hello world" one. 

But the real harm is being done by the i_own_your_ring0.ko module, which 
can be modprobed on all the systems where the signed "hello world" binary 
has been keyctl-ed before it was blacklisted.

In other words -- you blacklist the population of the key on systems by 
blakclisting the key-carrying binary, but the key remains trusted on 
whatever system the binary has been processed by keyctl before. Right?

If so, that's a clear difference from normal X.509 chain of trust (i.e. 
the difference between having the key signed, and having the binary 
signed).

-- 
Jiri Kosina
SUSE Labs
