Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaDOFgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:36:37 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47139 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaDOFge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <534C4E5D.40508@semaphore.gr>
References: <534C4E5D.40508@semaphore.gr>
Date: Tue, 15 Apr 2014 11:06:33 +0530
Message-ID: <CAKohpo=6fK0DzvPq_a=kEKV4kSBWjyEBzQoS5eqVAAGstb6=2A@mail.gmail.com>
Subject: Re: [PATCH 05/20] cpufreq: dbx500: Use cpufreq_for_each_entry macro
 for iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 02:38, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> The cpufreq core supports the cpufreq_for_each_entry macro helper
> for iteration over the cpufreq_frequency_table, so use it.
>
> It should have no functional changes.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/dbx500-cpufreq.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
> index 412a78b..2a0635c 100644
> --- a/drivers/cpufreq/dbx500-cpufreq.c
> +++ b/drivers/cpufreq/dbx500-cpufreq.c
> @@ -45,7 +45,7 @@ static struct cpufreq_driver dbx500_cpufreq_driver = {
>
>  static int dbx500_cpufreq_probe(struct platform_device *pdev)
>  {
> -       int i = 0;
> +       struct cpufreq_frequency_table *pos;
>
>         freq_table = dev_get_platdata(&pdev->dev);
>         if (!freq_table) {
> @@ -60,9 +60,8 @@ static int dbx500_cpufreq_probe(struct platform_device *pdev)
>         }
>
>         pr_info("dbx500-cpufreq: Available frequencies:\n");
> -       while (freq_table[i].frequency != CPUFREQ_TABLE_END) {
> -               pr_info("  %d Mhz\n", freq_table[i].frequency/1000);
> -               i++;
> +       cpufreq_for_each_entry(pos, freq_table) {
> +               pr_info("  %d Mhz\n", pos->frequency / 1000);
>         }

Remove {}
