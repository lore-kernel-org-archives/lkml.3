Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaHKOLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:11:54 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50407 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaHKOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:11:53 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E8CF26.9050707@roeck-us.net>
Date: Mon, 11 Aug 2014 07:11:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce writer
 locking)
References: <53E6CF2B.6090709@roeck-us.net> <CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com> <20140810193308.GA31867@redhat.com> <53E7DB59.6020300@roeck-us.net> <CA+55aFz3vW_qnrwa6kWMsN1pGbjnyGXGBNhH=DO0berKgyOtgQ@mail.gmail.com> <53E7FDB5.4070607@roeck-us.net> <CA+55aFyus4Le7EeCEaJpcVVshtwK93Et1C0AkPaC=5QnXJYjGw@mail.gmail.com> <20140811114822.GA2122@redhat.com>
In-Reply-To: <20140811114822.GA2122@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 04:48 AM, Oleg Nesterov wrote:
> On 08/10, Linus Torvalds wrote:
>>
>> So that should just be converted to assert_spin_is_locked().
>
> I still think that lockdep_assert_held() is better. Unlike
> assert_spin_locked() it checks that this lock is held by us, and this
> is what we want in this case.
>

assert_spin_locked maps to "BUG_ON(!raw_spin_is_locked(x))"
which it seems is exactly what the current code is doing.
I submitted a patch to make that change to use assert_spin_locked.
Presumably the author had a reason for using BUG_ON and not
lockdep_assert_held(), ie to perform the checks all the time
and not just while debugging. For me this was the safe change
to make. Anything else should, in my opinion, come from the
original author who introduced the code.

Guenter

