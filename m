Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3ILFgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:36:17 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:52633 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3ILFgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <52310E43.1090808@intel.com>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
	<2703632.ul5ekQh5oq@vostro.rjw.lan>
	<CAKohpo=RKB-_EO=cjaOorAfN=y_cMgJg-j6=xtX71a-TwujgsA@mail.gmail.com>
	<2013615.oHjWkmedue@vostro.rjw.lan>
	<CAKohpokEZcwF-zL6rTXYyC_x=SJzGFvdvxqvmvyhJHa8nPXogQ@mail.gmail.com>
	<52310E43.1090808@intel.com>
Date: Thu, 12 Sep 2013 11:06:14 +0530
Message-ID: <CAKohpomuJNQmk5fg5en5usPgipj7hzXUVNMhz1MjAS-47X4Ggg@mail.gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 06:13, Rafael J. Wysocki
<rafael.j.wysocki@intel.com> wrote:
> Yes, if you can point to a specific driver having this problem.

There are so many of those (I know it because I went through almost all drivers
recently with my cleanup series): cpufreq-cpu0, omap-cpufreq,
exynos-cpufreq, etc..

They all do this:

A. If new freq is more than old: Increase voltage
B. Change freq
C. If new freq is less than old: decrease voltage
