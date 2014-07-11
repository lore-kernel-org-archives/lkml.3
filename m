Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaGKRzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:55:36 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:59029 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGKRzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140711164931.GA18473@redhat.com>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
	<20140711164931.GA18473@redhat.com>
Date: Fri, 11 Jul 2014 10:55:33 -0700
X-Google-Sender-Auth: SJfBkqeY5Uc35Qre_3PWDuD0oM4
Message-ID: <CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com>
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
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

On Fri, Jul 11, 2014 at 9:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/10, Kees Cook wrote:
>>
>> This adds the ability for threads to request seccomp filter
>> synchronization across their thread group (at filter attach time).
>> For example, for Chrome to make sure graphic driver threads are fully
>> confined after seccomp filters have been attached.
>>
>> To support this, locking on seccomp changes via thread-group-shared
>> sighand lock is introduced, along with refactoring of no_new_privs. Races
>> with thread creation are handled via delayed duplication of the seccomp
>> task struct field and cred_guard_mutex.
>>
>> This includes a new syscall (instead of adding a new prctl option),
>> as suggested by Andy Lutomirski and Michael Kerrisk.
>
> I do not not see any problems in this version,

Awesome! Thank you for all the reviews. :) If Andy and Michael are
happy with this too, I think this is in good shape. \o/

-Kees

>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
>



-- 
Kees Cook
Chrome OS Security
