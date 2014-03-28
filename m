Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaC1Ncy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:32:54 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:56011 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaC1Ncw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:32:52 -0400
MIME-Version: 1.0
In-Reply-To: <1396013356.31134.27.camel@joe-AO722>
References: <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
	<f6aa622dc5acfd3ab9b1360973c0d15b3972c6b6.1396001532.git.viresh.kumar@linaro.org>
	<1396013356.31134.27.camel@joe-AO722>
Date: Fri, 28 Mar 2014 19:02:52 +0530
Message-ID: <CAKohpo=TrJk1A1VYJEohEPH_OHOodq2HPoqDDi-fyhnbDfU4Ag@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: use kzalloc() to allocate memory for cpufreq_frequency_table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joe Perches <joe@perches.com>
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

On 28 March 2014 18:59, Joe Perches <joe@perches.com> wrote:
> There seems to be some sort of bug fix in the
> patch at the very end too?

I have mentioned that in the log:

Along with that we also remove use of .driver_data from SPEAr driver as it
doesn't use it at all. Also, writing zero to .driver_data is not required for
powernow-k8 as it is already zero.

> Perhaps a better fix would be to use kcalloc for
> all the allocs with a multiply.

That would make the change very big now as there are lots of drivers
which are already using kzalloc() and so wouldn't like to do that in this
patch atleast..
