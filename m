Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaCXIdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:33:25 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48431 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaCXIdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140324092112.74f930d3@amdc2363>
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
	<20140324092112.74f930d3@amdc2363>
Date: Mon, 24 Mar 2014 14:03:20 +0530
Message-ID: <CAKohpom95rVO4AP6spzHWp3Oy6Lxmm3OnJte6d-E+vrdDQ2UUg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: set value of CPUFREQ_BOOST_FREQ to 0xABABABAB
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 March 2014 13:51, Lukasz Majewski <l.majewski@samsung.com> wrote:
> I think that a name of the patchset, for which the current setting
> causes problem would be welcome here.

I couldn't find a lkml link to the exact message earlier, but it was discussed
here:

https://patchwork.kernel.org/patch/3865481/

> Otherwise, I can only ask why it is not possible to add
> #define SPECIAL_SETTING ~3 ?

Driver wants to use this field for +ve and -ve values and it should be free
to do so.... And ~2 was creating problems when he used -3 for this field..
If we make it ~3, then he will face problem for -4..

So, I used a special value 0xABABABAB here whose integer value is:
-1414812757

The only other option we have is to add another field "bool boost" in
cpufreq_frequency_table, which is the last thing I wanted to do.

And that's the point Gautham was trying to make in one of our IRC
chats as well..
