Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab3KRLCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:02:07 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43039 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3KRLB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:01:58 -0500
MIME-Version: 1.0
In-Reply-To: <5289F29B.8050806@intel.com>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
	<5974906.WAPp3f3eVY@vostro.rjw.lan>
	<CAKohpo=PoAaYgLNEVkkTC6tzAH=5hKw4VWTsrjt2jQnr7+6Q_w@mail.gmail.com>
	<5229929.5JRiWnF6CT@vostro.rjw.lan>
	<5289A80B.7080808@linaro.org>
	<5289F29B.8050806@intel.com>
Date: Mon, 18 Nov 2013 16:31:58 +0530
Message-ID: <CAKohpo=UjSqzE+Jg0s3taykHu4VinNUvLLhRm6pUXiyUc5F-3w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, jinchoi@broadcom.com,
        Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2013 16:27, Lan Tianyu <tianyu.lan@intel.com> wrote:
> How about introducing a resume/suspend callback pointer or list(if there
> are several places that need to deal with cpu resume/suspend) in the
> struct cpu and populate it in the cpufreq_add_dev()?
>
> The suspend/resume() of cpu_subsys needs to check the callback pointer
> and run it if available.

That's almost a new infrastructure then and looks more hackish :)
Apart from that even cpufreq would be a bit hacky as we don't really need
per-cpu callbacks..
