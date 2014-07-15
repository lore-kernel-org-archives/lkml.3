Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaGOByI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:54:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32001 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaGOByG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:54:06 -0400
Message-ID: <53C48986.5010109@oracle.com>
Date: Tue, 15 Jul 2014 11:53:10 +1000
From: James Morris <james.l.morris@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>	<20140711164931.GA18473@redhat.com>	<CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com> <CAGXu5jJJsiTxxn5UijkBz7jpWgqg01BS=Zc0WbHXbs0vH_xPMQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJJsiTxxn5UijkBz7jpWgqg01BS=Zc0WbHXbs0vH_xPMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 04:59 AM, Kees Cook wrote:
> Hi James,
>
> Is this series something you would carry in the security-next tree?
> That has traditionally been where seccomp features have landed in the
> past.
>
> -Kees
>
>
> On Fri, Jul 11, 2014 at 10:55 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Fri, Jul 11, 2014 at 9:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> On 07/10, Kees Cook wrote:
>>>>
>>>> This adds the ability for threads to request seccomp filter
>>>> synchronization across their thread group (at filter attach time).
>>>> For example, for Chrome to make sure graphic driver threads are fully
>>>> confined after seccomp filters have been attached.
>>>>
>>>> To support this, locking on seccomp changes via thread-group-shared
>>>> sighand lock is introduced, along with refactoring of no_new_privs. Races
>>>> with thread creation are handled via delayed duplication of the seccomp
>>>> task struct field and cred_guard_mutex.
>>>>
>>>> This includes a new syscall (instead of adding a new prctl option),
>>>> as suggested by Andy Lutomirski and Michael Kerrisk.
>>>
>>> I do not not see any problems in this version,
>>
>> Awesome! Thank you for all the reviews. :) If Andy and Michael are
>> happy with this too, I think this is in good shape. \o/
>>
>> -Kees
>>
>>>
>>> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
>>>
>>
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security
>
>
>

Yep, certainly.

