Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab3BZIiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:38:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38947 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751515Ab3BZIiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:38:03 -0500
Message-ID: <1361867881.2023.16.camel@joe-AO722>
Subject: Re: [PATCH v3 2/2] kexec: Use min_t to simplify logic
From: Joe Perches <joe@perches.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 26 Feb 2013 00:38:01 -0800
In-Reply-To: <512C4881.90409@cn.fujitsu.com>
References: <512C44E4.70907@cn.fujitsu.com> <512C4881.90409@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 13:30 +0800, Zhang Yanfei wrote:
> This is just a tweak: using min_t to simplify logic of variable
> assignments.
> 
> v3:
> - cast type of (PAGE_SIZE - (maddr & ~PAGE_MASK)) into size_t.

Why?  Isn't this just a redundant cast?

> diff --git a/kernel/kexec.c b/kernel/kexec.c
[]
> @@ -822,13 +822,9 @@ static int kimage_load_normal_segment(struct kimage *image,
[]
> +		mchunk = min_t(size_t, mbytes,
> +			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));

#define min_t(type, x, y) ({			\
	type __min1 = (x);			\
	type __min2 = (y);			\
	__min1 < __min2 ? __min1: __min2; })


