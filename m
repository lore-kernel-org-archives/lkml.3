Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaLBMuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:50:11 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53187 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaLBMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:50:10 -0500
Message-ID: <1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Date: Tue, 02 Dec 2014 04:50:07 -0800
In-Reply-To: <1417494919-4577-2-git-send-email-oakad@yahoo.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	 <1417494919-4577-2-git-send-email-oakad@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-02 at 15:35 +1100, Alex Dubov wrote:
> Present patch introduces exceptionally easy to use, low latency and low
> overhead mechanism for transferring file descriptors between cooperating
> processes:
> 
>     int sendfd(pid_t pid, int sig, int fd)
> 
> Given a target process pid, the sendfd() syscall will create a duplicate
> file descriptor in a target task's (referred by pid) file table pointing to
> the file references by descriptor fd. Then, it will attempt to notify the
> target task by issuing a Posix.1b real-time signal (sig), carrying the new
> file descriptor as integer payload. If real-time signal can not be enqueued
> at the destination signal queue, the newly created file descriptor will be
> promptly closed.
> 
> Signed-off-by: Alex Dubov <oakad@yahoo.com>
> ---

User A can send fd(s) to processes belonging to user B, even if user B
does (probably) not want this to happen ?

Also, relying on signals seems quite old fashion these days. How about
multi-threaded programs wanting separate channels to receive fds ?

Ability to flood fds and fill target file descriptors table looks very
dangerous to me. Some programs could break as they expect they control
fd allocations.

I like the idea of not having to use AF_UNIX and stick to a well defined
interface, but I do not like this asynchronous model.

Thanks.


