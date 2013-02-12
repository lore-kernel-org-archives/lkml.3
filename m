Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3BLEDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:03:46 -0500
Received: from relay3.sgi.com ([192.48.152.1]:44351 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754771Ab3BLEDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:03:44 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: RE: [PATCH v2 linux-next 2/2] cpufreq: Convert the
 cpufreq_driver_lock to use the rcu
Thread-Topic: [PATCH v2 linux-next 2/2] cpufreq: Convert the
 cpufreq_driver_lock to use the rcu
Thread-Index: AQHOBA5rBQ8ceIvOaEijZLr8F17MgphvcnMAgAVr1KaAAJxPgIAAJE91
Date: Tue, 12 Feb 2013 04:03:42 +0000
Message-ID: <74F10842A85F514CA8D8C487E74474BB2D30DF27@P-EXMB1-DC21.corp.sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
 <16615226.2vj4EkkIZJ@vostro.rjw.lan>
 <74F10842A85F514CA8D8C487E74474BB2D30DC9E@P-EXMB1-DC21.corp.sgi.com>,<1953281.cgEiiBGo0f@vostro.rjw.lan>
In-Reply-To: <1953281.cgEiiBGo0f@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.149.23.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, your right.  I completely misread that section.
It'll take me a few days to respin and retest properly.

Thanks, 
Nate

________________________________________
From: Rafael J. Wysocki [rjw@sisk.pl]
Sent: Monday, February 11, 2013 1:36 PM
To: Nathan Zimmer
Cc: viresh.kumar@linaro.org; linux-kernel@vger.kernel.org; linux-pm@vger.kernel.org; cpufreq@vger.kernel.org
Subject: Re: [PATCH v2 linux-next 2/2] cpufreq: Convert the cpufreq_driver_lock to use the rcu

On Monday, February 11, 2013 05:13:30 PM Nathan Zimmer wrote:
> There are some spots that I need to give a much deeper review, cpufreq_register_driver for example.
>
> But I believe
> > @@ -196,7 +195,7 @@ static void __cpufreq_cpu_put(struct cpufreq_policy *data, bool sysfs)
> >  {
> >       if (!sysfs)
> >               kobject_put(&data->kobj);
> > -     module_put(cpufreq_driver->owner);
> > +     module_put(rcu_dereference(cpufreq_driver)->owner);
> >  }
> would be ok.  In the documentation whatisRCU.txt they give a very similar example.

Well, the very same document states the following:

        Note that the value returned by rcu_dereference() is valid
        only within the enclosing RCU read-side critical section.

Thanks,
Rafael


--
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.