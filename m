Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaFAIF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 04:05:57 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:34020 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFAIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 04:05:51 -0400
Date: Sun, 1 Jun 2014 10:05:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] split BPF out of core networking
Message-ID: <20140601080546.GB29062@gmail.com>
References: <1401586941-4274-1-git-send-email-ast@plumgrid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401586941-4274-1-git-send-email-ast@plumgrid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> This patch set splits BPF out of core networking into generic component

>   net: filter: split filter.c into two files
>   net: filter: split BPF out of core networking
> 
>  arch/Kconfig           |    3 +-
>  include/linux/filter.h |    2 +
>  net/Kconfig            |    4 +
>  net/Makefile           |    1 +
>  net/bpf/Makefile       |    5 +
>  net/bpf/core.c         | 1063 ++++++++++++++++++++++++++++++++++++++++++++++++
>  net/core/filter.c      | 1023 +---------------------------------------------
>  7 files changed, 1079 insertions(+), 1022 deletions(-)
>  create mode 100644 net/bpf/Makefile
>  create mode 100644 net/bpf/core.c

I like the splitup, but please put it into lib/bpf/ or kernel/bpf/ to 
signal its 'generic', 'core' nature, to be used in many subsystems 
outside of networking.

Thanks,

	Ingo
