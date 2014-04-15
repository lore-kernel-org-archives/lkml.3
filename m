Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaDOFpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:45:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45916 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaDOFpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <534C4E86.4060304@semaphore.gr>
References: <534C4E86.4060304@semaphore.gr>
Date: Tue, 15 Apr 2014 11:15:20 +0530
Message-ID: <CAKohpon7+VSvLROB7jqd2mUMk=zDSwDPOTuOEkJBMkPdRnNZFw@mail.gmail.com>
Subject: Re: [PATCH 09/20] cpufreq: longhaul: Use cpufreq_for_each_entry macro
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

On 15 April 2014 02:39, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> The cpufreq core supports the cpufreq_for_each_entry macro helper
> for iteration over the cpufreq_frequency_table, so use it.
>
> It should have no functional changes.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/longhaul.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
> index d00e5d1..6de99c4 100644
> --- a/drivers/cpufreq/longhaul.c
> +++ b/drivers/cpufreq/longhaul.c
> @@ -528,6 +528,7 @@ static int longhaul_get_ranges(void)
>
>  static void longhaul_setup_voltagescaling(void)
>  {
> +       struct cpufreq_frequency_table *freq;

Be consistent and use 'pos' here as well.
