Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaLCGsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:48:30 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:55075 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaLCGs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:48:28 -0500
Message-ID: <1417589306.5303.120.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Date: Tue, 02 Dec 2014 22:48:26 -0800
In-Reply-To: <CAPs88r_5GYAmWhW9rwj8c6oAjy8RZYih2mBubgvqRXfcgiUzYw@mail.gmail.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	 <1417494919-4577-2-git-send-email-oakad@yahoo.com>
	 <1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAPs88r_Dz+UqwhqAcKwXuLZGz4n=NocD-0FuOZug5UGH64p_8w@mail.gmail.com>
	 <1417534380.5303.64.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAPs88r-jZ5FvCHQjArKXhpX1YRg3O4NdUFtLizraF6nZ9SjFKw@mail.gmail.com>
	 <1417538574.5303.69.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAPs88r_5GYAmWhW9rwj8c6oAjy8RZYih2mBubgvqRXfcgiUzYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 13:11 +1100, Alex Dubov wrote:

> Kindly enlighten me, how are you going to use any file descriptor in a
> 128 threads program in a scalable way (socket and all)? How this
> approach will be different when using signalfd()?

Thats the point : use one different channel (AF_UNIX socket, or AF_INET
listener...) per thread.

Each thread uses epoll() on a private epoll fd, and a dedicated channel
to get fds from other processes.

Sharing a signalfd() would be terrible, like using accept() on a single
listener socket :(

Your proposed interface, being tied to legacy signal(s), do not allow
for many multiple channels.

Sorry, but using signals is simply a no go for me.


