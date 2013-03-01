Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3CAAAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:00:43 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35480 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3CAAAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:00:42 -0500
Date: Fri, 1 Mar 2013 00:00:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130301000020.GA13796@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz>
 <20130228225115.GA12360@srcf.ucam.org>
 <alpine.LNX.2.00.1302282357210.11745@pobox.suse.cz>
 <20130228230518.GA12717@srcf.ucam.org>
 <alpine.LNX.2.00.1303010040280.11745@pobox.suse.cz>
 <20130228234743.GA13709@srcf.ucam.org>
 <alpine.LNX.2.00.1303010049490.11745@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303010049490.11745@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 12:52:51AM +0100, Jiri Kosina wrote:
> On Thu, 28 Feb 2013, Matthew Garrett wrote:
> > If you've loaded an x.509 certificate into the kernel and it's later 
> > revoked, any module signed with the key is going to be loadable until 
> > it's revoked. I don't see an especially large difference here?
> 
> i_own_your_ring0.ko can be modprobed long after blacklisting of "hello 
> world" binary hash has happened on the very particular machine in its dbx 
> (as there is no link, in a x509-chain-of-trust-sense, between the hash of 
> the PE binary and the i_own_your_ring0.ko signature key).

Ah, I see what you mean. Yes, we should probably keep track of the 
linkage between the original hash and the key in the kernel and then 
invalidate the key if a corresponding dbx update is pushed, but it still 
seems likely that any attacker pushing the key onto your system would 
push the evil module simultaneously. The "I have an evil key but no evil 
module installed" case seems less likely.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
