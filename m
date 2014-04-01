Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaDAUXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:23:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57339 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaDAUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:23:27 -0400
Date: Tue, 1 Apr 2014 21:22:35 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jim Lieb <jlieb@panasas.com>, Jeff Layton <jlayton@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>, bfields@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Thoughts on credential switching
Message-ID: <20140401212235.770843a0@alan.etchedpixels.co.uk>
In-Reply-To: <CALCETrX7mxsWTsvcZJ=i0GOPvUp7TRvbrgNCq3Ajk8YK7FFnaA@mail.gmail.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
	<20140331114459.4b3638f8@alan.etchedpixels.co.uk>
	<CALCETrX7mxsWTsvcZJ=i0GOPvUp7TRvbrgNCq3Ajk8YK7FFnaA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do we include credfd fds sitting in Unix sockets?

Ouch

> Hmm.  What if we had initial_creds and creds, and initial_creds never
> changed unless explicitly requested.  There wouldn't be any way to
> revert to initial_creds, but may_ptrace would check initial_creds
> *and* creds.  This is a little hacky, and it might break Android (I'm
> not really sure how the zygote thing works), but it could do the
> trick.

That mirros setfsuid and seteuid type behaviour so seems sensible enough.
