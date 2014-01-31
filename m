Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaAaChL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:37:11 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:58705 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaAaChI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:37:08 -0500
MIME-Version: 1.0
In-Reply-To: <4185.1391101387@warthog.procyon.org.uk>
References: <4185.1391101387@warthog.procyon.org.uk>
Date: Thu, 30 Jan 2014 18:37:07 -0800
X-Google-Sender-Auth: YnPtD1YF3zKWP8cwavrGQKZYluk
Message-ID: <CA+55aFxE+M54mSM7=nRP_frA7LDAQYyMW6UhcGq62hOP4bX5Kw@mail.gmail.com>
Subject: Re: RFC: KEYS: Is this too-big a behavioural change for a system call?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: ghudson@mit.edu, simo@redhat.com, sgallagh@redhat.com, keys@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 9:03 AM, David Howells <dhowells@redhat.com> wrote:
>
> I've been asked by Kerberos developers to slightly change the behaviour of the
> add_key() and request_key() system calls and a couple of the keyctl() functions
> - and I'm wondering if you'd be okay with it.

So the rule about ABI changes has always been: "If somebody notices
it, we revert it".

IOW, it's not so much that you can't make changes, it's that you
cannot make changes that break programs.

And quite frankly, I have no good way to judge. Your (5) _sounds_
fair, but who knows what odd things some distributions do. We'd have
to be very careful, in *particular* we'd need to make it very very
clear to the krb people that if the change scews over any old users,
it gets reverted with extreme prejudice. At that point, maybe they say
"never mind, we might as well just always make sure we have a session
keyring".

And no, we are *not* going to say "we'll just stop doing this in the
kernel and expect pam_keyinit to do it for us".

But James' suggestion to perhaps have a new version of add_key() with
new semantics could work - if it's worth the pain (because we *would*
have to maintain the old interface basically forever, so it would be
more of a "the new system call doesn't really deprecate the old one,
it just has more convenient semantics").

          Linus
