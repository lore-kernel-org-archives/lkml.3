Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaHAAok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:44:40 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54187 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaHAAoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140731150328.d2b57d5f6d7aafa33f5ad979@linux-foundation.org>
References: <20140718200804.GG13012@htj.dyndns.org>
	<20140731150328.d2b57d5f6d7aafa33f5ad979@linux-foundation.org>
Date: Thu, 31 Jul 2014 20:44:38 -0400
X-Google-Sender-Auth: LD4J_z8SaAPInCZ9tf42FNJ2kck
Message-ID: <CAOS58YOVv2xcRzwtAUrs7ZobhNLML6ZpLpUEZj+NoqOhR02KCA@mail.gmail.com>
Subject: Re: [PATCH percpu/for-3.17 1/2] percpu: implement percpu_pool
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Jul 31, 2014 at 6:03 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I don't think we should add facilities such as this.  Because if we do,
> people will use them and thereby make the kernel less reliable, for
> obvious reasons.
>
> It would be better to leave the nasty hack localized within
> blk-throttle.c and hope that someone finds a way of fixing it.

The thing is we need similar facilities in the IO path in other places
too. They share exactly the same characteristics - opportunistic
percpu allocations during IO which are expected to fail from time to
time and they will all implement fallback behavior on allocation
failures. I'm not sure how this makes the kernel less reliable. This
conceptually isn't different from atomic allocations which we also use
in a similar way. If you're worried that people might use this
assuming that it won't fail, an obvious solution is adding a failure
injection for debugging, but really except for being a bit ghetto,
this is just the atomic allocation for percpu areas.

Thanks.

-- 
tejun
