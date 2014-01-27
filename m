Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaA0X4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:56:53 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34176 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaA0X4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:56:52 -0500
MIME-Version: 1.0
In-Reply-To: <52E6E786.80301@gmail.com>
References: <20140127230326.GA877@www.outflux.net>
	<52E6E786.80301@gmail.com>
Date: Mon, 27 Jan 2014 15:56:51 -0800
X-Google-Sender-Auth: nNHrQVo4thuU-kseGLFWDZ9Ves4
Message-ID: <CAGXu5j+nyRM+4JbPwtnWpdO9mKTL15FTn0c0+8xK-kr0hJpgag@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: BUG on %n
From: Kees Cook <keescook@chromium.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 3:11 PM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 28/01/14 10:03, Kees Cook wrote:
>> Now that there has been a full release of the kernel, and all users
>> of %n have been dropped, switch to %n use triggering a BUG. Ignoring
>> arguments could be used to assist in information leaks if an arbitrary
>> format string was under the control of an attacker.
>
> Not sure I follow the reasoning. %n no longer does anything in the
> kernel, so there is no risk if it does manage to find its way into a
> printed string. BUG() is for unrecoverable errors, which this clearly isn't.
>
> Information leaks via injectable strings are still possible if an
> attacker can insert %x, %d, etc. %n is more problematic since it allows
> for code injection, which is why it got removed. %n is not however,
> required to get an infoleak via a format string, so I think the summary
> is also a bit misleading.

Yeah, I'm a bit uncomfortable with the BUG() too. The issue with %n is
that it would produce no output at all to skip arguments. With other
things, you have to take up output space, which may be limited. How
about just not skipping the argument? Leave the warn_on, etc?

-Kees

-- 
Kees Cook
Chrome OS Security
