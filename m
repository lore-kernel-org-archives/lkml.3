Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaIKTyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:54:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbaIKTyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:54:47 -0400
Message-ID: <5411FDE1.3060302@redhat.com>
Date: Thu, 11 Sep 2014 21:54:09 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 net-next 00/12] eBPF syscall, verifier, testsuite
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com> <CALCETrVBb_uQZpodv67XSTGVU40y6+9Ktw=3zAJgGV2mNJ=_0A@mail.gmail.com> <CAMEtUuyY0L2=tz5mSvQqR_=_oN18nA6V9fdbR8OiYTPbQth8AQ@mail.gmail.com>
In-Reply-To: <CAMEtUuyY0L2=tz5mSvQqR_=_oN18nA6V9fdbR8OiYTPbQth8AQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 10:21 PM, Alexei Starovoitov wrote:
...
>>>                char bpf_log_buf[LOG_BUF_SIZE];
>>
>> What happens if the size isn't LOG_BUF_SIZE?
>
> would do you mean?
> LOG_BUF_SIZE is just a user defined macro.
> Can be anything.

I believe, Andy means, what would happen if log_level > 0 but
the log_size is not big enough so that the human-readable error
text string from the verifier will fit into it? I presume that
will be truncated then ... hm.

> it's passed along with pointer:
>                         .log_buf = bpf_log_buf,
>                         .log_size = LOG_BUF_SIZE,
>                         .log_level = 1,
