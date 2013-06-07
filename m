Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3FGBsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:48:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3FGBsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:48:45 -0400
Message-ID: <51B13BF4.7090706@oracle.com>
Date: Fri, 07 Jun 2013 09:48:36 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, Neil Gu <qing.gu@oracle.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: update user_policy.max when _PPC updated
References: <51AE8BE4.8050409@oracle.com> <42861210.QMFsUVH8RU@vostro.rjw.lan> <51B08EB7.8080702@oracle.com> <2674436.upogMLa2Oh@vostro.rjw.lan>
In-Reply-To: <2674436.upogMLa2Oh@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/13 03:54, Rafael J. Wysocki wrote:
> Do you mean you set a limit in the BIOS setup and the kernel changed that limit
> on boot?

Sorry for the confusing.

The issue is when we disable hardcap before kernel boot up, after kernel bring
up, any changes of _PPC will update scaling_max_freq properly.

If we enable hardcap before kernel boot up, after kernel bring up, even we 
disable it, scaling_max_freq does not be updated to max frequency, the max 
frequency just up to the value when bring up.

Review related codes I found the limit came from user_policy.max, means when
we set user_policy.max to 1000MHZ when boot up, then any changes of _PPC could
not enlarge the scaling_max_freq, I think this is not as expected? please advise.

Thanks,
Joe
