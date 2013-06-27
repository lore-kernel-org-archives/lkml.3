Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3F0OmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:42:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19916 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3F0OmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:42:18 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-bb-51cc4f48e6f1
Date: Thu, 27 Jun 2013 16:42:04 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
Message-id: <20130627164204.370dc4a6@amdc308.digital.local>
In-reply-to: <CAKohpo=JKg17YWjTrOh25hHW=sXn8-TW=D8rhrovonwZBDarBg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
 <CAKohpo=EwapTp8epok30=_ZYLPeCR8_LhpBF5H724dE=+SwMLg@mail.gmail.com>
 <20130627125819.5c90da30@amdc308.digital.local>
 <CAKohpo=JKg17YWjTrOh25hHW=sXn8-TW=D8rhrovonwZBDarBg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQV0P/zOBBrteqVr8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW1zeNYfN4nPvEUaL240r2Cz6F/YyWTx52Mdm0XHk
	G7PFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZcx+18lWMFeiYunjj8wNjK3CXYycHBICJhIHbrxlgbDFJC7cW88GYgsJTGeUuHk0
	q4uRC8huZ5L4snE9I0iCRUBVYu7c3+wgNpuAnsTnu0+Zuhg5OEQEtCRe3kwFqWcW2M4icalp
	FtggYQEnia93foHV8wpYS3ye9AMszikQLLFr+X4WiAV/mSRWPLnNCpLgF5CUaP/3gxniIjuJ
	c582QDULSvyYfA/sUmagZZu3NbFC2PISm9e8ZZ7AKDgLSdksJGWzkJQtYGRexSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iREcU8+kdzCuarA4xCjAwajEw/uB8XSgEGtiWXFl7iFGCQ5mJRHe
	mcJnAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwNmit
	vHCUXer/gYcn9/X9Snb7866CK/XfF9XitG9pH35HPT4nfOHmycXCnVbuUk5bF/3+oK7ZLl3B
	vfF67watWXbHL/w673Y9K6Rd9CH79rnqMVs/BGsaMuUtuKgw+dEmhhP626qllUPfl2eVfGNN
	mqJUciK9t80j42fGsy6pSVJh3Zsqi6enKrEUZyQaajEXFScCAGZbqVClAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 16:46:44 +0530, Viresh Kumar wrote:
> @Rafael: We need you to jump into this discussion now, I don't
> have a good idea about what we should do :)
> 
> On 27 June 2013 16:28, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Do you have any idea of how to precisely set the load threshold?
> 
> I thought we are talking about cpu being in idle state.

If we _drop_ the idea with thermal subsystem to disable the boost,
the logic as far as I've understood shall here be as follow:

Only enable BOOST when one CPU load > THRESHOLD_MAX and other CPUs <
THRESHOLD_MIN

THRESHOLD_MIN & THRESHOLD_MAX are SoC specific. 

In my opinion the above constrain imposes policy to the cpufreq driver.

> 
> > As a side note:
> >
> > I've thought about this patch for some time and for me it looks
> > like we are mixing policy (number of busy CPUs) with abilities,
> > which shall be provided by the driver (boost).
> > Additionally, we can only roughly "estimate" [*] when boost shall
> > run and when it shall be turned off.
> 
> This is another problem in the patch you sent. User would simply
> enable or disable boost feature from userspace only once.

The above statement is definitely true for Intel. There HW manage the
frequency.

> 
> Now, if you disable it at high temperatures then its responsibility
> to enable it again. Which you are missing.

So thermal or "other solution" [*] shall disable boost when overheated
and enable it back when things cool down.

[*] @ Viresh & Rafael do you have any idea about the "other solution"
here?


> 
> > I think that, we shall leave this management [*] to the thermal
> > framework. This framework is designed exactly to protect from over
> > heating (it uses the same freq_table for passive CPU cooling) with
> > several trip points -> e.g. 40 deg (disable boost), 75 deg (impose
> > max freq as 1.0 GHz to cool down, 90 deg (shutdown immediately).
> > Please refer to PATH v4 7/7.
> 
> There might be platforms where overheating isn't a issue with boost,
> if it is only enabled while only one cpu is in use.

Could you elaborate more on this?

I thought, that with multi core one needs to keep itself inside
power/thermal dissipation envelope. 

> 
> > Unfortunately, since we dropped Kconfig flag for BOOST we cannot
> > impose "select THERMAL_FRAMEWORK", when flag for BOOST is enabled at
> > Kconfig.
> 
> Not a big deal, we can get that in if required.
> 
> > Ideally kernel shall not even build when CONFIG_CPUFREQ_BOOST
> > Kconfig flag is set and thermal for target architecture is not
> > correctly configured (including proper trip points).

This would prevent situation when somebody made a mistake and
had enabled boost, but for some reason had forgotten to
configure/enable thermal subsystem.

Moreover Kconfig's CONFIG_CPUFREQ_BOOST flag would indicate that user
enabled boost for some reason and he/she (presumably) knows what is
doing.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
