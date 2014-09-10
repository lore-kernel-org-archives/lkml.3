Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaIJLfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaIJLfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:35:53 -0400
Message-ID: <54103776.3080706@redhat.com>
Date: Wed, 10 Sep 2014 13:35:18 +0200
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
Subject: Re: [PATCH v11 net-next 12/12] bpf: mini eBPF library, test stubs
 and verifier testsuite
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com> <1410325808-3657-13-git-send-email-ast@plumgrid.com>
In-Reply-To: <1410325808-3657-13-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:10 AM, Alexei Starovoitov wrote:
> 1.
> the library includes a trivial set of BPF syscall wrappers:
> int bpf_create_map(int key_size, int value_size, int max_entries);
> int bpf_update_elem(int fd, void *key, void *value);
> int bpf_lookup_elem(int fd, void *key, void *value);
> int bpf_delete_elem(int fd, void *key);
> int bpf_get_next_key(int fd, void *key, void *next_key);
> int bpf_prog_load(enum bpf_prog_type prog_type,
> 		  const struct sock_filter_int *insns, int insn_len,
> 		  const char *license);
> bpf_prog_load() stores verifier log into global bpf_log_buf[] array
>
> 2.
> test stubs configure eBPF infra with 'unspec' map and program types.
> These are fake types used by user space testsuite only.
>
> 3.
> verifier tests valid and invalid programs and expects predefined
> error log messages from kernel.
> 40 tests so far.
>
> $ sudo ./test_verifier
>   #0 add+sub+mul OK
>   #1 unreachable OK
>   #2 unreachable2 OK
>   #3 out of range jump OK
>   #4 out of range jump2 OK
>   #5 test1 ld_imm64 OK
>   ...
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

Since we already have an extensive BPF test suite, that is, lib/test_bpf.c,
which currently also does sanity checks for the classic BPF verifier, is
there a reason these verifier test cases cannot be extended/integrated there
as well but have to go to kernel/bpf/test_stub.c resp. samples/bpf/test_verifier.c ?
I don't like that we put testing code into kernel/bpf/ whereas we already
have a BPF test infrastructure in the kernel elsewhere.
