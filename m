Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaGPVog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:44:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55583 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751327AbaGPVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:44:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
Date: Thu, 17 Jul 2014 00:02:49 +0200
Message-ID: <16164926.ZsJxe6UV3e@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 07:37:30 PM Saravana Kannan wrote:
> Preliminary patch. Not tested. Just sending out to give an idea of what I'm
> looking to do. Expect a lot more simplification when it's done.
> 
> Benefits:
> * A lot more simpler code.
> * Less stability issues.
> * Suspend/resume time would improve.
> * Hotplug time would improve.
> * Sysfs file permissions would be maintained.
> * More policy settings would be maintained across suspend/resume.
> * cpufreq stats would be maintained across hotplug for all CPUs.

One problem.  The real hotplug (when the CPU actually goes away) depends on
offline removing all that stuff for it.  How are you going to address that?

Rafael

