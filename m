Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbaKSV4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:56:02 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39199 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaKSVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:55:59 -0500
Date: Wed, 19 Nov 2014 16:55:57 -0500 (EST)
Message-Id: <20141119.165557.1477971698958867828.davem@davemloft.net>
To: ast@plumgrid.com
Cc: fengguang.wu@intel.com, hannes@stressinduktion.org, dborkman@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bpf: fix arraymap NULL deref and missing
 overflow and zero size checks
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416360736-9531-1-git-send-email-ast@plumgrid.com>
References: <1416360736-9531-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 13:55:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 18 Nov 2014 17:32:16 -0800

> - fix NULL pointer dereference:
> kernel/bpf/arraymap.c:41 array_map_alloc() error: potential null dereference 'array'.  (kzalloc returns null)
> kernel/bpf/arraymap.c:41 array_map_alloc() error: we previously assumed 'array' could be null (see line 40)
> 
> - integer overflow check was missing in arraymap
> (hashmap checks for overflow via kmalloc_array())
> 
> - arraymap can round_up(value_size, 8) to zero. check was missing.
> 
> - hashmap was missing zero size check as well, since roundup_pow_of_two() can
> truncate into zero
> 
> - found a typo in the arraymap comment and unnecessary empty line
> 
> Fix all of these issues and make both overflow checks explicit U32 in size.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> This silly NULL deref bug and missing overflow check was an oversight when
> I refactored the code from two allocations (kmalloc for struct bpf_array and
> kcalloc for array of elements) in the first implementation of arraymap
> into one allocation which is this code.

Applied, thanks.
