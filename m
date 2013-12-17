Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3LQA0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:26:30 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:60588 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3LQA03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <1387229564-19517-3-git-send-email-john.stultz@linaro.org>
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
	<1387229564-19517-3-git-send-email-john.stultz@linaro.org>
Date: Mon, 16 Dec 2013 16:26:28 -0800
X-Google-Sender-Auth: k04EBaEVmZkrHGeP8TrwghUmFaA
Message-ID: <CAMbhsRRMMMreYzLMZHxjrRrKj0rZdS5SjLNbpGUuW93mg+Q65w@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] staging: ion: Fix possible null pointer dereference
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        kbuild test robot <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 1:32 PM, John Stultz <john.stultz@linaro.org> wrote:
> The kbuild test robot reported:
>
> drivers/staging/android/ion/ion_system_heap.c:122 alloc_largest_available() error: potential null dereference 'info'.  (kmalloc returns null)
>
> Where the pointer returned from kmalloc goes unchecked for failure.
>
> This patch adds a simple check for a null return, and handles the error.
>
> XXX: Not sure if continue or 'return NULL' is the right thing to do.

Returning NULL is fine, there is no reason the kmalloc is going to
succeed if it retries, and it will just have to allocate more of them
if it starts fulfilling the allocation with smaller order chunks.

Allocating the struct before entering the loop might make error handling easier.
