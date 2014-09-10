Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaIJJD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:03:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaIJJD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:03:57 -0400
Message-ID: <541013CE.6020307@redhat.com>
Date: Wed, 10 Sep 2014 11:03:10 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 net-next 00/12] eBPF syscall, verifier, testsuite
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com>
In-Reply-To: <1410325808-3657-1-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:09 AM, Alexei Starovoitov wrote:
...
>             struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
>                 int map_fd;
>                 void *key;
>                 union {
>                     void *value;
>                     void *next_key;
>                 };
>             };
>
>             struct { /* anonymous struct used by BPF_PROG_LOAD command */
>                 enum bpf_prog_type    prog_type;
>                 __u32                 insn_cnt;
>                 const struct bpf_insn *insns;
>                 const char            *license;
>                 __u32                 log_level; /* verbosity level of eBPF verifier */
>                 __u32                 log_size;  /* size of user buffer */
>                 void                  *log_buf;  /* user supplied buffer */

What is log buffer? Would that mean the verifier will return an error
string if the program will not pass it, or if not, what other data?
I think the man page is missing how to examine the returned verifier
log buffer data.
