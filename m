Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaLFENu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:13:50 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36220 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaLFENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:13:48 -0500
MIME-Version: 1.0
In-Reply-To: <20141205132250.6f2f9ec1@lxorguk.ukuu.org.uk>
References: <1417597255-32530-1-git-send-email-oakad@yahoo.com>
	<20141205132250.6f2f9ec1@lxorguk.ukuu.org.uk>
Date: Sat, 6 Dec 2014 15:13:48 +1100
Message-ID: <CAPs88r-CH+x3srCCcoXdBvno3t1mN__TgaTKRKPR43_u1_5+fg@mail.gmail.com>
Subject: Re: syscall: introduce sendfd() syscall (v.2)
From: Alex Dubov <alex.dubov@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2014 at 12:22 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>
>> 2.a. If task A has sufficient capabilities to send signals to task B, then
>> task A is already in position to do anything it wants with task B, including
>> killing it outright.
>
> Not entirely true.
>
> - We have securirty models like SELinux
> - We have namespaces and being able to send an fd between namespaces is
>   not quite as flexible as you would make it
>
> I suspect therefore it needs security hooks but otherwise looks more sane
> than the current AF_UNIX approach.
>

The best part about signal transport compared to anything in net/ is
that it adheres to very straightforward and simple API contract. That
is, you can tweak it here and there and still keep everything working.

1. adding an additional capability flag to selinux does not appear to
be that complicated (it's got 4 capabilities related to signal
handling already, fifth is not going to make much difference)

2. sending fds between namespaces may be prohibited outright; this
would not be an unreasonable prohibition. A more flexible model may
also be feasible, but I wonder if necessary.
