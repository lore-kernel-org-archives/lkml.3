Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab3B0WiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:38:09 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:63208 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3B0WiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:38:06 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302271417000.7155@chino.kir.corp.google.com>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
	<1361945258-24420-2-git-send-email-john.stultz@linaro.org>
	<alpine.DEB.2.02.1302271417000.7155@chino.kir.corp.google.com>
Date: Wed, 27 Feb 2013 14:38:05 -0800
Message-ID: <CAMP5XgcjdZk5MZ9v+W5phgWgE4Q0Pc_2FfopapjctsV6sdguLQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] staging: android: lowmemorykiller: Add config option
 to support oom_adj values
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: David Rientjes <rientjes@google.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 2:18 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 26 Feb 2013, John Stultz wrote:
>
>> From: Arve Hjønnevåg <arve@android.com>
>>
>> The conversion to use oom_score_adj instead of the deprecated oom_adj
>> values breaks existing user-space code. Add a config option to convert
>> oom_adj values written to oom_score_adj values if they appear to be
>> valid oom_adj values.
>>
>
> Umm, writes to /proc/pid/oom_adj already are converted to the
> /proc/pid/oom_score_adj scale linearly.  Heavy NACK to this patch since
> oom_adj is completely deprecated.

I know it is deprecated, but your change, staging: android,
lowmemorykiller: convert to use oom_score_adj, broke existing
user-space code that still write to /proc/pid/oom_adj. This option
lets you build a kernel that supports our user-space code until that
user-space has been converted to use /proc/pid/oom_score_adj.

-- 
Arve Hjønnevåg
