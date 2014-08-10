Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaHJXSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 19:18:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50161 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaHJXSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 19:18:16 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E7FDB5.4070607@roeck-us.net>
Date: Sun, 10 Aug 2014 16:18:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce writer
 locking)
References: <53E6CF2B.6090709@roeck-us.net>	<CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com>	<20140810193308.GA31867@redhat.com>	<53E7DB59.6020300@roeck-us.net> <CA+55aFz3vW_qnrwa6kWMsN1pGbjnyGXGBNhH=DO0berKgyOtgQ@mail.gmail.com>
In-Reply-To: <CA+55aFz3vW_qnrwa6kWMsN1pGbjnyGXGBNhH=DO0berKgyOtgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 02:10 PM, Linus Torvalds wrote:
> On Sun, Aug 10, 2014 at 1:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> That means that the broken configuration is (CONFIG_DEBUG_SPINLOCK=n,
>> CONFIG_SMP=n).
>> It also means that the BUG_ON checks introduced with the seccomp commit
>> will cause this configuration to fail hard at least for architectures where
>> CONFIG_SMP
>> can be disabled, and if those architectures use
>> include/linux/spinlock_types_up.h.
>
> Yes. This is why we have "assert_spin_locked()". You can't use
> BUG_ON(spin_is_locked()), and !spin_is_locked() tends to be even worse
> unless you can prove that nobody else can get the lock simultaneously.
>

git grep 'BUG_ON.*!spin_is_locked'

suggests that this may be a spreading sickness ... unless the other users
know for sure that SMP will always be configured.

What is the better fix ? Add NR_CPUS != 1 to the test, as mm does,
or remove it entirely ? Or something else ?

Guenter

