Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaAaBDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 20:03:22 -0500
Received: from tundra.namei.org ([65.99.196.166]:35118 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbaAaBDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 20:03:21 -0500
Date: Fri, 31 Jan 2014 12:07:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@linux-foundation.org, ghudson@mit.edu, simo@redhat.com,
        sgallagh@redhat.com, keys@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: RFC: KEYS: Is this too-big a behavioural change for a system
 call?
In-Reply-To: <4268.1391102040@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.02.1401311200310.11589@tundra.namei.org>
References: <4268.1391102040@warthog.procyon.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, David Howells wrote:

>  (5) Don't implicitly create a new anonymous keyring and don't implicitly set
>      the session keyring to the user-session keyring, but rather just fall back
>      to using the user-session keyring if there isn't a session keyring.
> 

> 
> That said, I do think that the Kerberos people have a valid point.  The current
> behaviour is poor.  I'm inclined to implement (5) or (6), probably (5).
> 
> This won't make any difference to most processes, ie.:
> 
>  (*) Those run from pam_keyinit-managed login shells.
> 
>  (*) Those that don't make use of libkrb5 or keyrings.
> 

So there are existing apps which will see semantic changes?

If so, we can't accept this change.

> In many ways, I'd like to just get rid of the user and user-session keyrings
> from the kernel entirely and have them created and maintained by pam_keyinit.
> The special keyring IDs:
> 
> 	KEY_SPEC_USER_KEYRING
> 	KEY_SPEC_USER_SESSION_KEYRING
> 
> and:
> 
> 	KEY_REQKEY_DEFL_USER_KEYRING
> 	KEY_REQKEY_DEFL_USER_SESSION_KEYRING
> 
> would then search your session keyring for keyrings called "_uid" and
> "_uid_ses" and return those.  Unfortunately, I think this is probably a
> much-too-big change at this point.
> 
> Any thoughts?

Getting it right is more important than the size of the change.

What about creating a new system call with the desired behavior, and 
deprecating the current one (or at least, making it a wrapper for the new 
call).

-- 
James Morris
<jmorris@namei.org>
