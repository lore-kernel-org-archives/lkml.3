Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbaCTUYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:24:17 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50518 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759424AbaCTUYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:24:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140320015634.GH3132@tassilo.jf.intel.com>
References: <1395163080-6290-1-git-send-email-keescook@chromium.org>
	<1395163080-6290-2-git-send-email-keescook@chromium.org>
	<20140319152521.04fe6665c67efe0c6a70d8a5@linux-foundation.org>
	<20140320015634.GH3132@tassilo.jf.intel.com>
Date: Thu, 20 Mar 2014 13:24:14 -0700
X-Google-Sender-Auth: atFb6awkq9iTG76e4enAEbbxecc
Message-ID: <CAGXu5jKmfp=6VT6uS9025w5DA8NCgFUj1+tQKtM-JgnLqB1UCw@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysctl: fix incorrect write position handling
From: Kees Cook <keescook@chromium.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Aaron Tomlin <atomlin@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Li Zefan <lizefan@huawei.com>,
        Dario Faggioli <raistlin@linux.it>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 6:56 PM, Andi Kleen <ak@linux.intel.com> wrote:
>>
>> Why are we fixing this?
>
> Also sysctl writes are root only anyways.
>
> Protecting root against root? Seems odd.

I think you misunderstood my motivation. I don't want to protect
anything here except a code auditor's mind. :)

The flaw itself was entirely with Chrome OS and poor filtering of
options that landed in procfs. The failure to recognize the needed
filtering came from the fact that procfs writes behave in an
unexpected manner.

I'd still be curious to see if we could improve things at all without
breaking actual uses. At least some better documentation seems
warranted.

-Kees

-- 
Kees Cook
Chrome OS Security
