Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab3CAOa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:30:58 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50777 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab3CAOa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:30:57 -0500
Date: Fri, 1 Mar 2013 09:30:33 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130301143033.GC4452@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
	pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
	keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
	Greg KH <gregkh@linuxfoundation.org>,
	Florian Weimer <fw@deneb.enyo.de>,
	Paolo Bonzini <pbonzini@redhat.com>
References: <30665.1361461678@warthog.procyon.org.uk>
 <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz>
 <20130228225115.GA12360@srcf.ucam.org>
 <20130301100052.GA20085@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301100052.GA20085@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 11:00:52AM +0100, Vojtech Pavlik wrote:
> 
> Mr. Blackhat then can load his i_own_your_ring0.ko module signed by his
> key on your system, having obtained root access previously.

The question will be what does Mr. Blackhat do with this
i_own_your_ring0.ko module.  The FUD that has been flung about is that
it would be possible for Mr. Blackhat to create a small, tight
partition containing a signed Linux kernel (from Red Hat or SuSE,
doesn't reallly matter), and enough of a initrd which would include
said i_own_your_ring0.ko module.  This would then be used in a bootkit
that would boot Linux and get ring0 access, and then use that to
create malware that would be used to infect Windows systems in a way
that wouldn't be detected by users.

It would essentially be the same as the bootsector virus, except it
would take 2 or 3 orders of magnitude more disk space, and probably
add one or two orders of magnitude more time to the boot time.
Whether this could be done in an undetectable fashion is an
interesting question, but the assertion is that it can be done, and so
we need to pour all sorts of unspeaking gunk into the kernel and
disable Systemtap to prevent this from happening.

> You call Microsoft, telling them what Mr. Blackhat has done.
> 
> They now can:
> 
> a) Do what you want: Disable Mr. Blackhat's account and revoke the hash
>    of his binary.
> 
> But also:
> 
> b) Say, "oh well, we're sorry this kills your security model, but it's
> enough for us that you already fully booted Linux to worry about Windows
> security, this affects only your distribution and we don't care".
> 
> c) Decide your security model is flawed, because you're abusing their
> signature process to mean something else from what they intended and
> revoke your shim hash instead.

Well, if this is being used to attack Windows machines (assuming that
it is possible to create a bootkit using a Linux kernel, and initrd,
and the signed i_pown_your_ring0.ko odule), it's unlikely that (b)
would be a likely outcome.

Both (a) and (c) would solve Microsoft's security problem.  They could
do (c), but that would result in the PR and Legal morass resulting
from the accusatoin that they are abusing their monopoly position.
I'm not an expert in how much backbone the European anti-trust folks
have, so I can't really comment on how likely they would pursue this,
or whether they would be successful in the end, but more importantly,
I suspect Microsoft wouldn't be sure either.

						- Ted
