Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaDRGYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:24:06 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42212 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDRGYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140418002858.GJ32556@tassilo.jf.intel.com>
References: <1397780183-24633-1-git-send-email-keescook@chromium.org>
	<1397780183-24633-2-git-send-email-keescook@chromium.org>
	<20140418002858.GJ32556@tassilo.jf.intel.com>
Date: Thu, 17 Apr 2014 23:24:00 -0700
X-Google-Sender-Auth: GvtG6-NPvdsv0UQep9t2ufuR8B8
Message-ID: <CAGXu5jLUo4tcwp+AKtd4_MN-PsC6W3wV7WEPvxv8Xt=0x0J5Vg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] sysctl: clean up char buffer arguments
From: Kees Cook <keescook@chromium.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andrew Shewmaker <agshew@gmail.com>, Jens Axboe <axboe@fb.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        Michael Ellerman <michael@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 5:28 PM, Andi Kleen <ak@linux.intel.com> wrote:
> BTW if you're worried about sysctl races you may also want to resurrect
> https://lkml.org/lkml/2009/12/20/214

Yeah, this had bothered me too while reading the code. The only "good"
news is that the strings are always NULL terminated and only "old"
contents can ever leak. Still, it's kind of horrible that there is no
locking here. :)

-Kees

-- 
Kees Cook
Chrome OS Security
