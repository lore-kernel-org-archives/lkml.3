Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbaGSQb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 12:31:29 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57054 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaGSQb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 12:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1407160307160.1775@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<1402655819-14325-5-git-send-email-dh.herrmann@gmail.com>
	<alpine.LSU.2.11.1407160307160.1775@eggly.anvils>
Date: Sat, 19 Jul 2014 18:31:26 +0200
Message-ID: <CANq1E4QF0-2e=ZDFvZkjRGunNaqSZ98D2Ah50bUqdgGcDXaPnQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] selftests: add memfd_create() + sealing tests
From: David Herrmann <dh.herrmann@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jul 16, 2014 at 12:07 PM, Hugh Dickins <hughd@google.com> wrote:
> On Fri, 13 Jun 2014, David Herrmann wrote:
>
>> Some basic tests to verify sealing on memfds works as expected and
>> guarantees the advertised semantics.
>>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>
> Thanks for whatever the fix was, I didn't hit any problem running
> this version repeatedly, on 64-bit and on 32-bit.

glibc does pid-caching so getpid() can be skipped once called. fork()
and clone() have to update it, though. Therefore, you shouldn't mix
fork() and clone() in the same process. I replaced my fork() call with
a simple clone() and the bug was gone.

Thanks
David
