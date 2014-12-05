Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaLENh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:37:58 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:59491 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaLENh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:37:57 -0500
Date: Fri, 5 Dec 2014 13:37:42 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alex Dubov <alex.dubov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
Message-ID: <20141205133742.4812db96@lxorguk.ukuu.org.uk>
In-Reply-To: <20141203104144.GA7495@localhost.localdomain>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-2-git-send-email-oakad@yahoo.com>
	<20141202170037.GG29748@ZenIV.linux.org.uk>
	<CAPs88r8m2QmaOWy623swGk=T3cyG85X3N7Z9tAp3nZvD0Tch+A@mail.gmail.com>
	<1417589446.5303.121.camel@edumazet-glaptop2.roam.corp.google.com>
	<20141203080800.GB5193@localhost.localdomain>
	<CAFLxGvzZQ59BRdWiPyVhCEUrR2UD3Ozdg2DHzRUqNQocf9o-EA@mail.gmail.com>
	<20141203104144.GA7495@localhost.localdomain>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 11:41:44 +0100
Richard Cochran <richardcochran@gmail.com> wrote:

> On Wed, Dec 03, 2014 at 09:17:37AM +0100, Richard Weinberger wrote:
> > Come on guys, get a cup of coffee and relax a bit...
> 
> I am relaxed, especially after I had a good laugh reading this:
> 
>    On a less related note, I hope you will agree that the simpler
>    mechanism for this very in-demand feature is long overdue on Linux
>    (every man and his dog are passing fds around these days).
> 
> Really, in years and years of unix programming, I have not yet felt
> the need to pass a file descriptor. Thats goes double for my dogs.

Its underused in part because you need a pointy hat to do it in Unix, but
it's a very common model elsewhere.

Whether you need the syscall or just to write sendfd() acceptfd() in
terms of AF_UNIX sockets in a library and bury the icky bits is another
question. I think the reality is you'd probably end up doing the library
*anyway* to deal with the fact it'll be 5 or more years before sendfd
percolated everywhere even if it was merged today.

Alan
