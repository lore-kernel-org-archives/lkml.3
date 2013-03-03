Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3CCDQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 22:16:35 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:49945 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3CCDQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 22:16:34 -0500
MIME-Version: 1.0
In-Reply-To: <1362280145.15793.70.camel@edumazet-glaptop>
References: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
 <1361820175.6781.13.camel@edumazet-glaptop> <CAOPLpQe5SfdWYv5QD4Fu90PXyS7SrSN_5Gntk2x5D5ea8ke64g@mail.gmail.com>
 <1362280145.15793.70.camel@edumazet-glaptop>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 2 Mar 2013 22:16:12 -0500
Message-ID: <CAOPLpQcpCsNoW6o7M4ALNhLtUFvJM0FSmavZPbz+Bjeq=mZitg@mail.gmail.com>
Subject: Re: sendfile and EAGAIN
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 10:09 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Using non blocking IO means the sender (and the receiver) must be able
> to perform several operations, as long as the whole transfert is not
> finished.

Certainly, and this is implemented.  But the receiver never gets the
rest of the data while the sender (most of the time) gets notified
that everything is sent.

I don't have a reduced test case yet.  Hopefully I'll get to it
sometime soon.  For now I worked around it by not using sendfile.
