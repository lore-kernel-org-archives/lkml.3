Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3LMLLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:11:09 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3LMLLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:11:06 -0500
Date: Fri, 13 Dec 2013 11:10:27 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Ryan Mallon <rmallon@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213111027.75bcc430@alan.etchedpixels.co.uk>
In-Reply-To: <CAGXu5j+mutYTfWWQ0fiKiTkO-Owo6SrikT=xhTrSP+kaDQge8g@mail.gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
	<20131212190659.GG13547@thunk.org>
	<CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
	<52AA4BC8.1080207@gmail.com>
	<CAGXu5j+mutYTfWWQ0fiKiTkO-Owo6SrikT=xhTrSP+kaDQge8g@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Totally true, but there's a million way to DoS a local machine. At
> least this way shows who's doing it. It's the DoSes that don't include
> attribution that I worry about. :)

So long as they compile out to nothingness for all the systems where this
stuff is useless (ie most of them because they are embedded or phones
etc) I don't see a big problem.

Note however if you trip one of those in any code with the console lock
held and your log goes to the consoles due to printk level or similar
you'll probably hang the box.

There are some other lock sequences that are going to do that too, so it
can't be placed arbitarily but will need the locking assumptions for each
non-obvious one documented clearly.

Alan
