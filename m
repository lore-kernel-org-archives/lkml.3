Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3IWBJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:09:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61813 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWBJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:09:15 -0400
Message-ID: <1379898516.5476.27.camel@marge.simpson.net>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
From: Mike Galbraith <bitbucket@online.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Jia He <jiakernel@gmail.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 23 Sep 2013 03:08:36 +0200
In-Reply-To: <523EC97D.8020707@colorfullife.com>
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com>
	 <1379837823.5499.34.camel@marge.simpson.net>
	 <1379838364.5499.39.camel@marge.simpson.net>
	 <523EC97D.8020707@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:9NAvGMUa0H6kWdDJRl8k6vNZnTQw62Iqa5dQwPokgLt
 7Dv6ylnzxAkImL3NDYbmhzj/D79Nq3YoLLNzKJiYp/IJu7YHht
 FdaWQW9kUegBmUhty1H8cvRdE0f7OB8FMMCzlDmd2DQkIxkeW/
 QL8jCgLQMjLdyuE0PwAdmqCMgSDmYQ+N4h5xtbWhFF2J3DqX+x
 GlPNnZqIQIE/MCnjAj0ObDuxat8v+DicE6BiyHh6VqkgoE4FFc
 QXOtsivuuzgENCWyde8dAVXZwuLcB/s3dGDq/Z/b1XfWO0FxY7
 f0iU562iBI2V0xSCMl5NB/0IbzTPSWsJyQOrH+YcLCwOn+k5j5
 bZUTZbUsKYHQqQQhwspaUhXcuxOpEExT1JWsMjLuvlAkOhJeXm
 ihGrcIG693Z9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 12:42 +0200, Manfred Spraul wrote:

> Mike: no, your patch makes it worse:
> - wait-for-zero semops still don't update sem_otime
> - sem_otime is initialized to sem_ctime. That's not mentioned in the 
> sysv standard.

So sem_otime = 0 is a specified semaphore state?  I thought the proggy
was busted for spinning on a (busted and) irrelevant stamp.

Man lernt nie aus.

-Mike

