Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaCCDmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:42:53 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47621 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaCCDma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:42:30 -0500
MIME-Version: 1.0
X-Originating-IP: [67.83.169.196]
In-Reply-To: <CAKohpomqu22Pt5_wYV3u2uC36AgfmrkvxLtJCGakdodEQFE-jQ@mail.gmail.com>
References: <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com>
	<20140226164142.GA18079@thin>
	<CAMpEsFFjR2e_kDn9-QuKcS3RjsSmru9XGjXqXXdO7sYeWdh9dw@mail.gmail.com>
	<20140226170847.GA18427@thin>
	<CAKohpomqu22Pt5_wYV3u2uC36AgfmrkvxLtJCGakdodEQFE-jQ@mail.gmail.com>
Date: Sun, 2 Mar 2014 22:42:29 -0500
Message-ID: <CA+C-WL-pnQne-Cz8MuSFPpcHH33ARbRRm-R6VT9aEKzgNHZQQg@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: cpufreq: Mark function as static in cpufreq.c
From: Patrick Palka <patrick@parcs.ath.cx>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:25 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Rashika,
>
> On 26 February 2014 22:08, Rashika Kheria <rashika.kheria@gmail.com> wrote:
>> Mark function as static in cpufreq.c because it is not
>> used outside this file.
>>
>> This eliminates the following warning in cpufreq.c:
>> drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for 'show_boost' [-Wmissing-prototypes]
>
> Can you please elaborate how this warning is related to
> the non-static definition of this function?

-Wmissing-prototypes warns when a non-static function is defined
before a corresponding prototype (usually inside an included header
file) is declared.  In such a case, it is impossible to reference the
non-static function from another file, and therefore the function
should be marked static (usually).  Hope that makes sense!
