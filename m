Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaHJVKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 17:10:51 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48942 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaHJVKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 17:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <53E7DB59.6020300@roeck-us.net>
References: <53E6CF2B.6090709@roeck-us.net>
	<CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com>
	<20140810193308.GA31867@redhat.com>
	<53E7DB59.6020300@roeck-us.net>
Date: Sun, 10 Aug 2014 14:10:49 -0700
X-Google-Sender-Auth: gKAkuMhjuZIT30ecMOHuEl5Op0c
Message-ID: <CA+55aFz3vW_qnrwa6kWMsN1pGbjnyGXGBNhH=DO0berKgyOtgQ@mail.gmail.com>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce writer locking)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 1:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> That means that the broken configuration is (CONFIG_DEBUG_SPINLOCK=n,
> CONFIG_SMP=n).
> It also means that the BUG_ON checks introduced with the seccomp commit
> will cause this configuration to fail hard at least for architectures where
> CONFIG_SMP
> can be disabled, and if those architectures use
> include/linux/spinlock_types_up.h.

Yes. This is why we have "assert_spin_locked()". You can't use
BUG_ON(spin_is_locked()), and !spin_is_locked() tends to be even worse
unless you can prove that nobody else can get the lock simultaneously.

           Linus
