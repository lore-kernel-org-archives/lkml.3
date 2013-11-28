Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3K1ImG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:42:06 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:54350 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3K1ImC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:42:02 -0500
MIME-Version: 1.0
In-Reply-To: <20131128063505.GN3556@cmpxchg.org>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
 <20131128063505.GN3556@cmpxchg.org>
From: William Dauchy <wdauchy@gmail.com>
Date: Thu, 28 Nov 2013 09:41:40 +0100
Message-ID: <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com>
Subject: Re: [PATCH] Fix race between oom kill and task exit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Ma, Xindong" <xindong.ma@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, azurIt <azurit@pobox.sk>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Thu, Nov 28, 2013 at 7:35 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Cc William and azur who might have encountered this problem.

Thank you for letting me know.
Note that before this patch I saw the one from Sameer Nanda
mm, oom: Fix race when selecting process to kill
https://lkml.org/lkml/2013/11/13/336

After applying this later one, I still have the issue I sent you (oom
killing a task outside cgroup i.e Task in / killed as a result of
limit of /lxc/foo) *but* I don't have a crash any more. So I was in
the process of reapplying your debug patch to send you a new report.

However, I'm now wondering if this present patch is a replacement of
Sameer Nanda's patch or if this a complementary patch.

Thanks,
-- 
William
