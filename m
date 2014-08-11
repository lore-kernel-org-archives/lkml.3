Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaHKLtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:49:43 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45495 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaHKLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:49:42 -0400
Date: Mon, 11 Aug 2014 04:49:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Manuel Lauss <manuel.lauss@gmail.com>
cc: Kees Cook <keescook@chromium.org>, Linux-MIPS <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: MIPS: hang in kmalloc with seccomp writer locks
In-Reply-To: <CAOLZvyFuDqi4+pEae=n7+ZJoAx-vca-pRS8ZAQqvTk-tSyPiwg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1408110448470.15519@chino.kir.corp.google.com>
References: <CAOLZvyFuDqi4+pEae=n7+ZJoAx-vca-pRS8ZAQqvTk-tSyPiwg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014, Manuel Lauss wrote:

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

Does enabling CONFIG_DEBUG_SPINLOCK fix the issue?
