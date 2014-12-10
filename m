Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaLJSih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:38:37 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:62223 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaLJSig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:38:36 -0500
MIME-Version: 1.0
In-Reply-To: <1418226774-30215-8-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
	<1418226774-30215-8-git-send-email-tj@kernel.org>
Date: Wed, 10 Dec 2014 21:38:35 +0300
Message-ID: <CAMo8BfJ_8Ob7hKpjnVKkeK3m8gh+cGZwNNQZWmPMa-dktXeUBA@mail.gmail.com>
Subject: Re: [PATCH 07/12] xtensa: use {cpu|node}mask pr_cont and seq output functions
From: Max Filippov <jcmvbkbc@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 6:52 PM, Tejun Heo <tj@kernel.org> wrote:
> Convert the existing user of cpu{mask|list}_scnprintf() and
> node{mask|list}_scnprintf() which use them just to printk or
> seq_printf() the resulting buffer to use the following functions
> instead respectively.
>
> * For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().
>
> * For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().
>
> Because these conversions usually break up a single output function
> call into multiple, the reduction is LOC isn't too big but it removes
> unnecessary complexity and/or arbitrary limit on the length printed.
>
> This patch is dependent on the previous patch ("bitmap, cpumask,
> nodemask: implement pr_cont variants of formatting functions") which
> is planned to go through -mm.  It'd be the easiest to route this
> together.  If this should go through the subsystem tree, please wait
> till the forementioned patch is merged to mainline.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: linux-xtensa@linux-xtensa.org
> ---
>  arch/xtensa/kernel/setup.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
