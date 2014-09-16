Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaIPTRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:17:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57271 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaIPTRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:17:13 -0400
Date: Tue, 16 Sep 2014 15:17:11 -0400 (EDT)
Message-Id: <20140916.151711.203074982751372582.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        dborkman@redhat.com, hannes@stressinduktion.org, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, pablo@netfilter.org,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 net-next 04/11] bpf: expand BPF syscall with
 program load/unload
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410808721-27493-5-git-send-email-ast@plumgrid.com>
References: <1410808721-27493-1-git-send-email-ast@plumgrid.com>
	<1410808721-27493-5-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 12:17:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 15 Sep 2014 12:18:34 -0700

> @@ -121,6 +132,21 @@ union bpf_attr {
>  			void __user *next_key;
>  		};
>  	};
> +
> +	struct { /* anonymous struct used by BPF_PROG_LOAD command */
> +		__u32 prog_type;	/* one of enum bpf_prog_type */
> +		__u32 insn_cnt;
> +		const struct bpf_insn __user *insns;
> +		const char __user *license;
> +	};
> +};

Again, these need syscall compat handling.  You may want to redesign
the types so that perhaps no compat layer translations will be needed.
