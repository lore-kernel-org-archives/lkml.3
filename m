Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3LLQxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:53:16 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63998 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3LLQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:53:09 -0500
Message-ID: <52A9E9F3.4090801@gmail.com>
Date: Thu, 12 Dec 2013 09:53:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf completion: complete 'perf kvm'
References: <1386758056-24618-1-git-send-email-artagnon@gmail.com> <1386758056-24618-2-git-send-email-artagnon@gmail.com> <20131211195046.GA2295@infradead.org> <52A8C36A.9000501@gmail.com> <CALkWK0m=0pJQoCKx+Xc+Do_JwX=NjqwA_wjM8W=spTQm5h5DHQ@mail.gmail.com>
In-Reply-To: <CALkWK0m=0pJQoCKx+Xc+Do_JwX=NjqwA_wjM8W=spTQm5h5DHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13, 2:09 AM, Ramkumar Ramachandra wrote:
> David Ahern wrote:
>> I don't like the command list being embedded in the completion script. It
>> will get outdated quickly.
>
> I could introduce a
>
>    $ perf kvm --list-cmds
>
> but that would mean a
>
>    printf("record report stat ..")
>
> in builtin-kvm.c, because the commands aren't in any sort of array.
>

That would work -- perhaps a #define or string near

    const char * const kvm_usage[] = {
         "perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
         NULL
     };

Building kvm_usage from the string would better - only 1 place listing 
the commands.

David
