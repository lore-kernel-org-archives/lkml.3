Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3LQAhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:37:16 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45041 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3LQAhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:37:14 -0500
Message-ID: <52AF9CB7.90003@linaro.org>
Date: Mon, 16 Dec 2013 16:37:11 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 2/3] staging: ion: Fix possible null pointer dereference
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>	<1387229564-19517-3-git-send-email-john.stultz@linaro.org> <CAMbhsRRMMMreYzLMZHxjrRrKj0rZdS5SjLNbpGUuW93mg+Q65w@mail.gmail.com>
In-Reply-To: <CAMbhsRRMMMreYzLMZHxjrRrKj0rZdS5SjLNbpGUuW93mg+Q65w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 04:26 PM, Colin Cross wrote:
> On Mon, Dec 16, 2013 at 1:32 PM, John Stultz <john.stultz@linaro.org> wrote:
>> The kbuild test robot reported:
>>
>> drivers/staging/android/ion/ion_system_heap.c:122 alloc_largest_available() error: potential null dereference 'info'.  (kmalloc returns null)
>>
>> Where the pointer returned from kmalloc goes unchecked for failure.
>>
>> This patch adds a simple check for a null return, and handles the error.
>>
>> XXX: Not sure if continue or 'return NULL' is the right thing to do.
> Returning NULL is fine, there is no reason the kmalloc is going to
> succeed if it retries, and it will just have to allocate more of them
> if it starts fulfilling the allocation with smaller order chunks.
>
> Allocating the struct before entering the loop might make error handling easier.

Ok, I had actually done that in my first pass, but then got worried the
allocation/free might have extra overhead in the case where the pool is
exhausted, so I stuck with the existing pattern. But if that's not a
common state, then I agree, it does make the handling simpler.

I'll rework this and re-submit. Thanks for the feedback!

thanks
-john
