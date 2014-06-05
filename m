Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaFETvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:51:36 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36241 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaFETvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <204d5b72194f81e638bd72bcc4b5ef9f089a56b2.1401728995.git.viresh.kumar@linaro.org>
References: <cover.1401728994.git.viresh.kumar@linaro.org>
	<204d5b72194f81e638bd72bcc4b5ef9f089a56b2.1401728995.git.viresh.kumar@linaro.org>
Date: Thu, 5 Jun 2014 12:51:30 -0700
X-Google-Sender-Auth: MmkssapPb2GNhs4aVCXzP4Bzeaw
Message-ID: <CAD=FV=W3gOMaJ3gFCA1p4-Ee8f5b+ntvgfmMX5Zj62-Wu9htzQ@mail.gmail.com>
Subject: Re: [PATCH V5 1/2] cpufreq: add support for intermediate (stable) frequencies
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh,

On Mon, Jun 2, 2014 at 10:19 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Douglas Anderson, recently pointed out an interesting problem due to which
> udelay() was expiring earlier than it should.
>
> While transitioning between frequencies few platforms may temporarily switch to
> a stable frequency, waiting for the main PLL to stabilize.
>
> For example: When we transition between very low frequencies on exynos, like
> between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
> No CPUFREQ notification is sent for that. That means there's a period of time
> when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
> and 300MHz. And so udelay behaves badly.
>
> To get this fixed in a generic way, lets introduce another set of callbacks
> get_intermediate() and target_intermediate(), only for drivers with
> target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.
>
> get_intermediate() should return a stable intermediate frequency platform wants
> to switch to, and target_intermediate() should set CPU to to that frequency,
> before jumping to the frequency corresponding to 'index'. Core will take care of
> sending notifications and driver doesn't have to handle them in
> target_intermediate() or target_index().
>
> NOTE: ->target_index() should restore to policy->restore_freq in case of
> failures as core would send notifications for that.
>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  Documentation/cpu-freq/cpu-drivers.txt | 29 ++++++++++++++-
>  drivers/cpufreq/cpufreq.c              | 67 ++++++++++++++++++++++++++++++----
>  include/linux/cpufreq.h                | 25 +++++++++++++
>  3 files changed, 112 insertions(+), 9 deletions(-)

LGTM.  Thanks for doing this!  :)

Reviewed-by: Doug Anderson <dianders@chromium.org>
