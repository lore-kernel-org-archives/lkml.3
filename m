Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3BVCca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:32:30 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:48524 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab3BVCcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:32:22 -0500
MIME-Version: 1.0
In-Reply-To: <10415300.xy5iOWqAMD@vostro.rjw.lan>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
	<31684733.Z4gjoGKC1g@vostro.rjw.lan>
	<CAKohponQ0MVwbTpM-6MasewMQ7MWcL-3nFjf2d7DpAZbWKsNqw@mail.gmail.com>
	<10415300.xy5iOWqAMD@vostro.rjw.lan>
Date: Fri, 22 Feb 2013 08:02:21 +0530
Message-ID: <CAKohpokVj33ySMHPHs+a-dgq9fxuuRo_uLZzy=8cs4JFjQVnDw@mail.gmail.com>
Subject: Re: [PATCH V2 4/4] cpufreq: Get rid of "struct global_attr"
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 08:03, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, February 22, 2013 07:47:44 AM Viresh Kumar wrote:
>> On 22 February 2013 05:15, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > Why did you change all of the lines of this macro instead of changing just the
>> > one line you needed to change?
>>
>> I didn't like the indentation used within the macro. So did it.
>
> In general, things like that are for separate cleanup patches.  If you mix
> functional changes with cleanups, poeple get confused and it's difficult to see
> what's needed and what's "optional".
>
> I know it's tempting to fix stuff like that along with doing functional
> changes and I do that sometimes.  Not very often, though, and with care.

Even i give similar comments sometimes but forget these while writing my
patches :)

Anyway, fixup:

commit b1bbb99467d56140cf3a8a2b70e61b456aa46e48
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Feb 22 07:59:20 2013 +0530

    fixup! cpufreq: Get rid of "struct global_attr"
---
 drivers/cpufreq/intel_pstate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e795134..49846b9 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -273,12 +273,12 @@ static void intel_pstate_debug_expose_params(void)
 /************************** debugfs end ************************/

 /************************** sysfs begin ************************/
-#define show_one(file_name, object)                            \
-static ssize_t show_##file_name                                        \
-(struct cpufreq_policy *policy, char *buf)                     \
-{                                                              \
-       return sprintf(buf, "%u\n", limits.object);             \
-}
+#define show_one(file_name, object)                                    \
+       static ssize_t show_##file_name                                 \
+       (struct cpufreq_policy *policy, char *buf)                      \
+       {                                                               \
+               return sprintf(buf, "%u\n", limits.object);             \
+       }
