Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaLATPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:15:20 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40240 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaLATPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:15:18 -0500
MIME-Version: 1.0
In-Reply-To: <5476F3C5.8020709@linaro.org>
References: <1416993266-16514-1-git-send-email-kiran.kumar@linaro.org>
	<CAMbhsRR0XzJ9ouYuoE2z+oCR9jRt8XBEfuVgd7sLJMg24bMKyQ@mail.gmail.com>
	<5476F3C5.8020709@linaro.org>
Date: Mon, 1 Dec 2014 11:15:17 -0800
X-Google-Sender-Auth: u9j9CSl4QLtOAFGZygk4jKwzHzA
Message-ID: <CAMbhsRSWRhVoZiX1L4WopGZfaEpNBkCR67yO94ei2W03zpN2rQ@mail.gmail.com>
Subject: Re: [RFC v3] debug: prevent entering debug mode on errors
From: Colin Cross <ccross@android.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Kiran Raparthy <kiran.kumar@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 1:49 AM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> On 26/11/14 17:45, Colin Cross wrote:
>> The original patch was more useful as it allowed re-enabling break on
>> panic on specific devices where you were trying to debug a
>> reproducible issue.  What about using a module_param similar to
>> kgdbreboot, but setting the default based on CONFIG_PANIC_TIMEOUT to
>> avoid extra configuration?
>
> This change was due to my review so perhaps I'd better answer this...
>
> panic_timeout is the value of the panic sysctl. In addition to the
> normal sysctl tooling (which I don't think is available on most android
> systems), its value can be set using panic=0 on the kernel command line
> or via /proc/sys/kernel/panic at runtime.
>
> CONFIG_PANIC_TIMEOUT merely sets the default value of the sysctl. I
> guess perhaps the patch description could be improved to make this clearer.
>
> Therefore, the only loss of function I expected versus the original is
> that it would be hard to get as far as a reproducible panic if the
> system also has a ton of reproducible oopses that we don't want to fix.
> Is such a use-case important?

OK, works for me.
