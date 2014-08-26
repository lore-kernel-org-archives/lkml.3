Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaHZBHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:07:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40255 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbaHZBHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:07:20 -0400
Date: Mon, 25 Aug 2014 18:07:18 -0700 (PDT)
Message-Id: <20140825.180718.137768107010295086.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        rostedt@goodmis.org, dborkman@redhat.com, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, brendan.d.gregg@gmail.com,
        namhyung@kernel.org, hpa@zytor.com, akpm@linux-foundation.org,
        keescook@chromium.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 net-next 4/6] bpf: enable bpf syscall on x64 and i386
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409014858-1410-5-git-send-email-ast@plumgrid.com>
References: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
	<1409014858-1410-5-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 18:07:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 25 Aug 2014 18:00:56 -0700

> -
> +asmlinkage long sys_bpf(int cmd, unsigned long arg2, unsigned long arg3,
> +			unsigned long arg4, unsigned long arg5);

Please do not add interfaces with opaque types as arguments.

It is impossible for the compiler to type check the args at
compile time when userspace tries to use this stuff.
