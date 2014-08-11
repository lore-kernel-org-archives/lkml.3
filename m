Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaHKPMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:12:00 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64014 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaHKPL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:11:58 -0400
Date: Mon, 11 Aug 2014 08:11:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Manuel Lauss <manuel.lauss@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Linux-MIPS <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: MIPS: hang in kmalloc with seccomp writer locks
Message-ID: <20140811151153.GA14365@roeck-us.net>
References: <CAOLZvyFuDqi4+pEae=n7+ZJoAx-vca-pRS8ZAQqvTk-tSyPiwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLZvyFuDqi4+pEae=n7+ZJoAx-vca-pRS8ZAQqvTk-tSyPiwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:35:28PM +0200, Manuel Lauss wrote:
> Hi Kees,
> 
> My MIPS32 toys hang early during bootup at the first kmalloc() with
> seccomp enabled.
> I've bisected it to commit dbd952127d11bb44a4ea30b08cc60531b6a23d71
> ("seccomp: introduce writer locking").  And indeed, reverting this
> commit fixes the hang.
> 
> I'm not sure if seccomp is even working on MIPS, but I've never had
> problems with
> it before so I thought I let you know.
> 

Also see [1] and [2], the latter providing a patch to fix the problem.
The problem is only seen in unicore systems with lock debugging disabled.

Guenter

---
[1] https://lkml.org/lkml/2014/8/9/163
[2] https://lkml.org/lkml/2014/8/10/184
