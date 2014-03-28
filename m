Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaC1KdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:33:17 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55610 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaC1KdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140328111943.272d0bea@amdc2363>
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
	<b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
	<20140328111943.272d0bea@amdc2363>
Date: Fri, 28 Mar 2014 16:03:12 +0530
Message-ID: <CAKohpokNNN94pejJTXJR0txc3-THY7TdQ3Q2UNZEZPynNM-CHA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: create another field .flags in cpufreq_frequency_table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2014 15:49, Lukasz Majewski <l.majewski@samsung.com> wrote:
> One little remark - since cpufreq_frequency_tables are defined as
> static it seems like we don't need to explicitly specify the 0, for
> flags field.
>
> Something like {, L13, 200 * 1000}, shall be enough.

This looks awkward, writing zero is better. The other option was to do
it like this:

{.driver_data = L13, .frequency = 200 * 1000}

But I didn't wanted to make such changes in this patch.

>> +/* Special Values of .flags field */
>> +#define CPUFREQ_BOOST_FREQ     0x1
>
> Maybe (1 << 0) to explicitly show that those are flags.

Will do that in case I resend this patch, otherwise it wouldn't
harm for now.

>>  struct cpufreq_frequency_table {
>> +       unsigned int    flags;
>>         unsigned int    driver_data; /* driver specific data, not
>
> The driver_data shall be changed to int. However I suppose that it will
> be done at separate patch.

I am not planning to change it for now. People storing 'int' into this
field would read it back into 'int' and so things would work as normal
I suppose.
