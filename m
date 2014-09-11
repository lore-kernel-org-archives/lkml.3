Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaIKLdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:33:25 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:50541 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaIKLdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:33:22 -0400
MIME-Version: 1.0
In-Reply-To: <1410430423-1246-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
References: <1410430423-1246-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Date: Thu, 11 Sep 2014 17:03:22 +0530
Message-ID: <CAKohpo=uB252XLfx3tHPA8uk5RPkWB0SPQ_UxzVw70c-DWuHWg@mail.gmail.com>
Subject: Re: [PATCH v3] cpufreq: powernv: Set the cpus to nominal frequency
 during reboot/kexec
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 15:43, Shilpasri G Bhat
<shilpa.bhat@linux.vnet.ibm.com> wrote:
> This patch ensures the cpus to kexec/reboot at nominal frequency.
> Nominal frequency is the highest cpu frequency on PowerPC at
> which the cores can run without getting throttled.
>
> If the host kernel had set the cpus to a low pstate and then it
> kexecs/reboots to a cpufreq disabled kernel it would cause the target
> kernel to perform poorly. It will also increase the boot up time of
> the target kernel. So set the cpus to high pstate, in this case to
> nominal frequency before rebooting to avoid such scenarios.
>
> The reboot notifier will set the cpus to nominal frequncy.
>
> Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
> Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
> Changes v2->v3:
> We return EBUSY when cpufreq governor tries to change the frequency
> after rebooting is set to true. This results in console being flushed
> with error messages indicating failed attempts to change the
> frequency. So instead of returning EBUSY we return 0 to stop the
> governor from changing the frequency without alerting a failure to
> do the same on reboot, as this  is not an errorneaos condition.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
