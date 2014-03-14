Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaCNQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:29:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36627 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaCNQ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:29:01 -0400
Date: Fri, 14 Mar 2014 16:28:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140314162831.1caf342c@alan.etchedpixels.co.uk>
In-Reply-To: <CAGXu5jLZcWh5WD0L8s3Q-GXdXCMnA57qtjfdFfQbv0fxYcuCTQ@mail.gmail.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
	<20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	<1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<CAGXu5jLZcWh5WD0L8s3Q-GXdXCMnA57qtjfdFfQbv0fxYcuCTQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The command line problem here is a total red herring. If you've got a
> measured kernel, you have a measured command line. (If not, you don't

That would be the sensible approach, but it has some quite drastic
ramifications.

> have a measured kernel.) Dealing with the command line has nothing to
> do with enforcing the ring0/uid0 boundary which is what this patch
> series does.

It has a huge relevance. You are signing blocks of code and loading them
into your kernel. In case it's escaped your notice those blocks of code
have behaviour which is considerably customisable by passing module
arguments to them. In many cases they don't actually check those
arguments. If I can set module paramters I already 0wn your box so many
different ways its not even funny.

> Right. As mentioned, we've been over all of this before. We cannot
> change the meaning of capabilities (nor expand their coverage to
> existing interfaces) without breaking userspace. Since we cannot break
> userspace, we must create a different policy system that covers this
> new thing we want to do and keeps the new policy distinctly separate.

So you have everything checked twice all over the kernel and you
guarantee that people will get it wrong. I don't see the point of putting
a broken implementation in the kernel. If you want to do security do it
*right* and do it once. You think every single person who adds a driver
is going to muddle through two interfaces (and in future no doubt more if
we don't fix it properly) and get it right each time ?

The 'breaking userspace' argument is bullshit already. The whole *point*
of the measured kernel is to break userspace. You are deliberately
breaking a pile of functionality, much of it undersirable in order to
achieve your measured system.

The only "don't break" case that matters is if the measured stuff isn't
in use. In those cases we don't need to break anything.

Alan
