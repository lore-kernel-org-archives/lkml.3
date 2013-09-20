Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3ITRFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:05:30 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50439 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3ITRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:05:29 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaAryP9BVEeEPWBS+_BuTB75c-Zqv01eRNmwDqKgvyz-Q@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
	<CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
	<CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com>
	<CACRpkdaAryP9BVEeEPWBS+_BuTB75c-Zqv01eRNmwDqKgvyz-Q@mail.gmail.com>
Date: Fri, 20 Sep 2013 22:35:29 +0530
Message-ID: <CAKohpomg=0YYHYu1Eh4MGW=_h3cppntBr1dQWMjCj_=AuRBDPQ@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 21:09, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Sep 20, 2013 at 11:35 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1460,6 +1460,9 @@ unsigned int cpufreq_get(unsigned int cpu)
>>  {
>>         unsigned int ret_freq = 0;
>>
>> +       if (cpufreq_disabled() || !cpufreq_driver)
>> +               return -ENOENT;
>> +
>
> But given that a cpufreq driver is just like any other driver, isn't the
> proper thing to do to return -EPROBE_DEFER?

Its not a probe and so that error type doesn't look correct to me..
Also, its only taking care of things when this routine is called without
a cpufreq driver and so it should be fine..
