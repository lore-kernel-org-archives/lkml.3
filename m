Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaBQEGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 23:06:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53059 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaBQEGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 23:06:52 -0500
Message-ID: <53018ABA.20005@zytor.com>
Date: Sun, 16 Feb 2014 20:06:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@kernel.org, linux-kernel@vger.kernel.org, stefani@seibold.net,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/vdso] x86, vdso: Instead of dummy functions, include
 < linux/spinlock_up.h>
References: <1392587568-7325-10-git-send-email-stefani@seibold.net> <tip-bd9ee7fd99f127ee1306289415141d45792c97f3@git.kernel.org>
In-Reply-To: <tip-bd9ee7fd99f127ee1306289415141d45792c97f3@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 07:51 PM, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  bd9ee7fd99f127ee1306289415141d45792c97f3
> Gitweb:     http://git.kernel.org/tip/bd9ee7fd99f127ee1306289415141d45792c97f3
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Sun, 16 Feb 2014 19:47:01 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Sun, 16 Feb 2014 19:47:01 -0800
> 
> x86, vdso: Instead of dummy functions, include <linux/spinlock_up.h>
> 
> The list of dummy functions is insufficient.  However, instead of
> having a full list of dummy functions we can include
> <linux/spinlock_up.h> which contains the (trivial) implementations
> that we use on uniprocessor.
> 
> There aren't supposed to be any spinlocks at all in the VDSO, of
> course.
> 

That didn't work either.  I thought I was clever, but it didn't work at
all.  Multiple build failures across numerous configurations.  This is
turning into a total headache.

The "right" way to fix this is presumably to refactor a bunch of header
files so that the vdso code doesn't have to include a bunch of kernel
internal headers, but that is a lot of work.

	-hpa


