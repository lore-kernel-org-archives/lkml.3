Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbaHYVdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:33:52 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47611 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464AbaHYVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:33:50 -0400
MIME-Version: 1.0
In-Reply-To: <1408911690-7598-7-git-send-email-ast@plumgrid.com>
References: <1408911690-7598-1-git-send-email-ast@plumgrid.com>
	<1408911690-7598-7-git-send-email-ast@plumgrid.com>
Date: Mon, 25 Aug 2014 14:33:48 -0700
Message-ID: <CAHA+R7MTJcsDpw=5P7hOsVf_pEOEZX_=cLrcw4ep4xntUxk=3Q@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 06/29] bpf: add lookup/update/delete/iterate
 methods to BPF maps
From: Cong Wang <cwang@twopensource.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 1:21 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> 'maps' is a generic storage of different types for sharing data between kernel
> and userspace.
>
> The maps are accessed from user space via BPF syscall, which has commands:
>
> - create a map with given type and attributes
>   fd = bpf_map_create(map_type, struct nlattr *attr, int len)
>   returns fd or negative error
>
> - lookup key in a given map referenced by fd
>   err = bpf_map_lookup_elem(int fd, void *key, void *value)
>   returns zero and stores found elem into value or negative error
>
> - create or update key/value pair in a given map
>   err = bpf_map_update_elem(int fd, void *key, void *value)
>   returns zero or negative error
>
> - find and delete element by key in a given map
>   err = bpf_map_delete_elem(int fd, void *key)
>
> - iterate map elements (based on input key return next_key)
>   err = bpf_map_get_next_key(int fd, void *key, void *next_key)


I think you need to document the bpf() syscall instead of wrappers on it,
from a developer's point of view. You will anyway need to document a new
syscall with a man page as a general rule.

In the changelog I mean something like:

err = bpf(BPF_MAP_LOOKUP_ELEM, ...);
