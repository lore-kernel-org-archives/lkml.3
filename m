Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3AaI67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:58:59 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:47343 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3AaI65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:58:57 -0500
X-Greylist: delayed 101179 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 03:58:57 EST
MIME-Version: 1.0
In-Reply-To: <20130131085555.GB30667@balto.lan>
References: <1359620064-14751-1-git-send-email-fabio.baltieri@linaro.org>
	<CAKohponV-PPO8sqF=rzONLzPi7q-YFOPbrQgoBcNt_NjTJO6WQ@mail.gmail.com>
	<20130131085555.GB30667@balto.lan>
Date: Thu, 31 Jan 2013 14:28:56 +0530
X-Google-Sender-Auth: CAozXIoVeW-anm_-HIO8kjUD5gk
Message-ID: <CAOh2x==1ru3bddHnJOge=1rbpc6xwzKV5F5isJhAgwX_R=2TCw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: implement generic policy_is_shared
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 2:25 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Thu, Jan 31, 2013 at 02:01:27PM +0530, Viresh Kumar wrote:
>> On 31 January 2013 13:44, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
>> > Implement a generic helper function policy_is_shared() to replace the
>> > current dbs_sw_coordinated_cpus() at cpufreq level, so that it can be
>> > used by code other than cpufreq governors.
>> >
>> > Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
>> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
>> > ---
>> >  drivers/cpufreq/cpufreq_conservative.c | 2 +-
>> >  drivers/cpufreq/cpufreq_governor.c     | 8 --------
>> >  drivers/cpufreq/cpufreq_governor.h     | 1 -
>> >  drivers/cpufreq/cpufreq_ondemand.c     | 2 +-
>> >  include/linux/cpufreq.h                | 5 +++++
>>
>> Great,
>>
>> But, you missed few places:
>>
>> drivers/cpufreq/acpi-cpufreq.c:        if (bios_with_sw_any_bug &&
>> cpumask_weight(policy->cpus) == 1) {
>> drivers/cpufreq/cpufreq_stats.c:       if (policy &&
>> (cpumask_weight(policy->cpus) == 1)) {
>
> This doesn't look like the same thing to me!  Isn't this check here just
> to trigger during init (exit) on the first (last) cpu?  How would you
> replace it?

I don't think i am wrong, but i can be :)

So, i would replace these as:
drivers/cpufreq/acpi-cpufreq.c:        if (bios_with_sw_any_bug &&
cpumask_weight(policy->cpus) == 1) {
AS
drivers/cpufreq/acpi-cpufreq.c:        if (bios_with_sw_any_bug &&
!policy_is_shared(policy)) {

similarly for the other one too. The whole point is about checking if policy
is managing just one cpu or multiple cpus.
