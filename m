Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3KPEcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 23:32:06 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54545 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3KPEb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 23:31:58 -0500
Message-ID: <5286F536.70403@linaro.org>
Date: Sat, 16 Nov 2013 10:01:50 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianyu.lan@intel.com, nm@ti.com,
        jinchoi@broadcom.com, sebastian.capella@linaro.org
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <5020664.HldDXMO8cr@vostro.rjw.lan>
In-Reply-To: <5020664.HldDXMO8cr@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 November 2013 05:54 AM, Rafael J. Wysocki wrote:
> Will cpufreq work during system-wide power transitions (suspend/resume etc.)
> after this?  In particular, what about hibernation?

I am disabling governors as soon as we start suspend. So No, cpufreq wouldn't
work during suspend/resume. But once system is resumed we are starting it back
again.

Hibernation is probably not supported by my code yet.. I just went through
hibernation code quickly and it looks we don't send PM_SUSPEND_PREPARE or
PM_POST_SUSPEND notifications in case of hibernation. Correct?

And these are the notifications that we send:
- PM_HIBERNATION_PREPARE
- PM_POST_HIBERNATION
- PM_RESTORE_PREPARE
- PM_POST_RESTORE

If I am not wrong I need to stop governors on PM_HIBERNATION_PREPARE and need to
start them back on: PM_POST_HIBERNATION (I am a bit confused with this one. Does
this POST_HIBERNATION one happens at the end of going into hibernation? or after
booting back? I need a notifier at the end of restore)..

--
viresh
