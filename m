Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaHKLu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbaHKLuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:50:24 -0400
Date: Mon, 11 Aug 2014 13:48:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce
	writer locking)
Message-ID: <20140811114822.GA2122@redhat.com>
References: <53E6CF2B.6090709@roeck-us.net> <CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com> <20140810193308.GA31867@redhat.com> <53E7DB59.6020300@roeck-us.net> <CA+55aFz3vW_qnrwa6kWMsN1pGbjnyGXGBNhH=DO0berKgyOtgQ@mail.gmail.com> <53E7FDB5.4070607@roeck-us.net> <CA+55aFyus4Le7EeCEaJpcVVshtwK93Et1C0AkPaC=5QnXJYjGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyus4Le7EeCEaJpcVVshtwK93Et1C0AkPaC=5QnXJYjGw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10, Linus Torvalds wrote:
>
> So that should just be converted to assert_spin_is_locked().

I still think that lockdep_assert_held() is better. Unlike
assert_spin_locked() it checks that this lock is held by us, and this
is what we want in this case.

Plus it depends on CONFIG_LOCKDEP, this is probably good too.

Oleg.

