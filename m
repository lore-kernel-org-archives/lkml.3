Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaAPDOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:14:37 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:46652 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaAPDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:14:34 -0500
MIME-Version: 1.0
In-Reply-To: <1389840330.2944.104.camel@j-VirtualBox>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
	<1389745990-7069-4-git-send-email-jason.low2@hp.com>
	<1389840330.2944.104.camel@j-VirtualBox>
Date: Thu, 16 Jan 2014 10:14:33 +0700
X-Google-Sender-Auth: JxpBLRSGkw3dxzKBkZS1LaPGBc8
Message-ID: <CA+55aFwszXHtjOW53eBLV4aMD-cv0dg7xyBa0BtN1LS4XajwLw@mail.gmail.com>
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after too
 many tries
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 9:45 AM, Jason Low <jason.low2@hp.com> wrote:
>
> Any comments on the below change which unlocks the mutex before taking
> the lock->wait_lock to wake up a waiter? Thanks.

Hmm. Doesn't that mean that a new lock owner can come in *before*
you've called debug_mutex_unlock and the lockdep stuff, and get the
lock? And then debug_mutex_lock() will be called *before* the unlocker
called debug_mutex_unlock(), which I'm sure confuses things.

          Linus
