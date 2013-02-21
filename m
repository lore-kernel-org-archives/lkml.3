Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3BUUId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:08:33 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49327 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3BUUIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:08:30 -0500
Date: Thu, 21 Feb 2013 15:08:22 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130221200822.GD17322@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
	keyrings@linux-nfs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <567.1361470653@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <567.1361470653@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 06:17:33PM +0000, David Howells wrote:
> 
> There's a problem with your idea.
> 
>  (1) Microsoft's revocation certificates would be based on the hash of the PE
>      binary, not the key.
> 
>  (2) Re-signing would make the keys then dependent on our master key rather
>      than directly on Microsoft's.  Microsoft's revocation certificates[*]
>      would then be useless.
> 
>  (3) The only way Microsoft could then revoke the extra keys would be to
>      revoke our *master* key.

Well, this hypothetical service could also simply scan the Microsoft
revocation certificates (aka CRL's), and if the service detects a PE
hash that it relied upon to resign the module, it could then issue its
own CRL revoking the signature on the module.

If it is run this way, programmatically, I'll note that anyone can run
this service.  It doesn't have to be Red Hat.  It could be Linux
Foundation, if the LF wanted to support this whole code signing
insanity.  (Which I really think is completely overblown, and I'm
going to be amused when this blows to hell all of Red Hat's
investments in Systemtap, but whatever.)  Given that I think this
whole thing is insane, I completely agree with Linus's attempt to keep
this insanity as far away from the upstream kernel as we can.  :-/

     	      	     	       	   - Ted
