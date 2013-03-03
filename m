Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3CCBlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:41:37 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:65186 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3CCBlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:41:36 -0500
MIME-Version: 1.0
In-Reply-To: <1361820175.6781.13.camel@edumazet-glaptop>
References: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
 <1361820175.6781.13.camel@edumazet-glaptop>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 2 Mar 2013 20:41:14 -0500
Message-ID: <CAOPLpQe5SfdWYv5QD4Fu90PXyS7SrSN_5Gntk2x5D5ea8ke64g@mail.gmail.com>
Subject: Re: sendfile and EAGAIN
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 2:22 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I don't understand the issue.
>
> sendfile() returns -EAGAIN only if no bytes were copied to the socket.

There is something wrong/unexpected/...

I have a program which can use either sendfile or send.  When using
sendfile to transmit a large block (I've seen it with 900k) the
sendfile call does not transmit everything.  There receiver gets only
about 600k.  This is the situation when I think I've seen EAGAIN
errors from sendmail but I cannot just now reproduce it.  This is with
sockets of AF_UNIX type.

Are there any limits to take into account?
