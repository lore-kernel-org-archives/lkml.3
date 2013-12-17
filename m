Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3LQBWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:22:51 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36772 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3LQBWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:22:50 -0500
Message-ID: <52AFA766.9070804@linaro.org>
Date: Mon, 16 Dec 2013 17:22:46 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH 3/3] staging: ion: Avoid using rt_mutexes directly.
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>	<1387229564-19517-4-git-send-email-john.stultz@linaro.org> <CAMbhsRQOWKWBjQJWndr57Cz_Xf0EeU8jNMJOyiOEBHFRf=Tt=Q@mail.gmail.com>
In-Reply-To: <CAMbhsRQOWKWBjQJWndr57Cz_Xf0EeU8jNMJOyiOEBHFRf=Tt=Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 04:17 PM, Colin Cross wrote:
> The lock is only used to protect the heap's free_list and
> free_list_size members, and is not held for any long or sleeping
> operations.  Converting to a spinlock should prevent priority
> inversion without using the rt_mutex.  I'd also rename it to free_lock
> to so it doesn't get used as a general heap lock.

Hrm.. So at least a trivial conversion to use spinlocks doesn't quite
work out, as we call ion_buffer_destroy() in ion_heap_freelist_drain()
while holding the lock, and that calls all sorts of not safe stuff.

I'll spend some more time looking at it later tonight, but let me know
if you have an approach for this case in mind.

thanks
-john

