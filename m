Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaDYIXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:23:53 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40141 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaDYIXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:23:37 -0400
Message-ID: <535A1B5B.9000705@linux.vnet.ibm.com>
Date: Fri, 25 Apr 2014 13:52:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, mroos@linux.ee, linaro-kernel@lists.linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Set CPUFREQ_ASYNC_NOTIFICATION for drivers handling
 notification
References: <c6c53fee017018869c7524a487688edf902c1413.1398412138.git.viresh.kumar@linaro.org>
In-Reply-To: <c6c53fee017018869c7524a487688edf902c1413.1398412138.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042508-2674-0000-0000-00000DF57024
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 01:22 PM, Viresh Kumar wrote:
> CPUFREQ_ASYNC_NOTIFICATION was initially designed for drivers which don't want
> core to send notifications for them as they wouldn't finish frequency
> transitions in ->target_index().
>

And let's keep it that way. Overloading ASYNC_NOTIFICATION with other meanings
is a bad idea.
 
> But there were other kinds of drivers as well who don't have straight forward
> implementations of ->target_index() routines and wanted to handle notifications
> themselves.
> 

Looking at longhaul, powernow-k6 and powernow-k7, I think we can safely remove
the extra notifications from them and let them depend on the cpufreq core's set
of notifications. The patchset I posted just now uses that design.

Regards,
Srivatsa S. Bhat

