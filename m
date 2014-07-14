Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaGNTFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:05:04 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64756 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaGNTEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:04:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
 <20140711164931.GA18473@redhat.com> <CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Jul 2014 12:04:33 -0700
Message-ID: <CALCETrVXgA9a2f7VwnCYW4_XB+JAPRSR8xsuH_ZYbA82=ZozRw@mail.gmail.com>
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 10:55 AM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jul 11, 2014 at 9:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 07/10, Kees Cook wrote:
>>>
>>> This adds the ability for threads to request seccomp filter
>>> synchronization across their thread group (at filter attach time).
>>> For example, for Chrome to make sure graphic driver threads are fully
>>> confined after seccomp filters have been attached.
>>>
>>> To support this, locking on seccomp changes via thread-group-shared
>>> sighand lock is introduced, along with refactoring of no_new_privs. Races
>>> with thread creation are handled via delayed duplication of the seccomp
>>> task struct field and cred_guard_mutex.
>>>
>>> This includes a new syscall (instead of adding a new prctl option),
>>> as suggested by Andy Lutomirski and Michael Kerrisk.
>>
>> I do not not see any problems in this version,
>
> Awesome! Thank you for all the reviews. :) If Andy and Michael are
> happy with this too, I think this is in good shape. \o/

I think I'm happy with it.  Is it in git somewhere for easy perusal?
I have a cold, so my reviewing ability is a bit off, but I want to
take a look at the final version, and git is a little easier than
email for this.

--Andy
