Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab3BZIyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:54:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab3BZIyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:54:01 -0500
Date: Tue, 26 Feb 2013 00:53:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Joe Perches <joe@perches.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] kexec: Use min_t to simplify logic
Message-Id: <20130226005328.e2d31a97.akpm@linux-foundation.org>
In-Reply-To: <512C76FE.4070109@cn.fujitsu.com>
References: <512C44E4.70907@cn.fujitsu.com>
	<512C4881.90409@cn.fujitsu.com>
	<1361867881.2023.16.camel@joe-AO722>
	<512C76FE.4070109@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013 16:49:02 +0800 Zhang Yanfei <zhangyanfei@cn.fujitsu.com> wrote:

> >> diff --git a/kernel/kexec.c b/kernel/kexec.c
> > []
> >> @@ -822,13 +822,9 @@ static int kimage_load_normal_segment(struct kimage *image,
> > []
> >> +		mchunk = min_t(size_t, mbytes,
> >> +			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
> > 
> > #define min_t(type, x, y) ({			\
> > 	type __min1 = (x);			\
> > 	type __min2 = (y);			\
> > 	__min1 < __min2 ? __min1: __min2; })
> > 
> > 
> > 
> 
> Hmm, from the definition, the cast is redundant.
> 
> Maybe I misunderstood what Andrew meant in the mail related to v2:
> 
> "The types of PAGE_SIZE and PAGE_MASK are vague - iirc they once had
> different types on different architectures, so some form of casting is
> unavoidable here."
> 
> Andrew, could you please explain the casting you meant above?

I mean that a cast (or min_t, which is a cast) will be needed. 
The code you have here casts the same thing two times, which isn't
necessary.

