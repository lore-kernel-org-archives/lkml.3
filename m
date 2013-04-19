Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3DSTX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:23:56 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:64135 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3DSTXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <5169477D.1000400@gmx.de>
References: <1360862966-6376-1-git-send-email-jmaggard10@gmail.com>
	<5169477D.1000400@gmx.de>
Date: Fri, 19 Apr 2013 12:23:54 -0700
Message-ID: <CAKgsxVT3_ge2vxcGWzy6NJYPEGwB1Wbw2eE7a=JtWWBb8o4XVg@mail.gmail.com>
Subject: Re: fanotify: fix support of large files
From: Justin Maggard <jmaggard10@gmail.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com, LinoSanfilippo@gmx.de,
        tzvetanc@commtouch.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 4:54 AM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> Dear Justin,
>
> looking at the example at
> http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
> the large file support is enabled by passing O_LARGEFILE to fanotify_init:
>
>   if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
>                                     O_RDONLY | O_CLOEXEC | O_LARGEFILE)) <
> 0)
>
> Could you, please, check if this solves your issue.
>
> (I am resending this message because HTML was rejected by
> linux-kernel@vger.kernel.org).
>
> Best regards
>
> Heinrich Schuchardt
>

No, unfortunately that doesn't help.  I slightly modifed
fanotify-example.c to call perror() when read() fails, and here's the
output:

jmaggard@jmaggard-W520:~/fanotify-test$ sudo ./fanotify-example . &
[1] 7248
jmaggard@jmaggard-W520:~/fanotify-test$ Started monitoring directory '.'...
truncate -s 2047m 2047m
Received event in path '/home/jmaggard/fanotify-test/2047m' pid=7250 (unknown):
FAN_OPEN
FAN_CLOSE_WRITE
jmaggard@jmaggard-W520:~/fanotify-test$ truncate -s 2048m 2048m
read: Value too large for defined data type

-Justin
