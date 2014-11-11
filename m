Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaKKDzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:55:41 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54474 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKKDzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:55:39 -0500
MIME-Version: 1.0
In-Reply-To: <1415199239-19019-5-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
	<1415199239-19019-5-git-send-email-prarit@redhat.com>
Date: Tue, 11 Nov 2014 09:25:38 +0530
Message-ID: <CAKohpokHSY1qqSq=D0FZK3Px1c-Ro8nVbD+dBqUNSPWUXiiiJQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] cpufreq, policy->initialized count must be atomic
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2014 20:23, Prarit Bhargava <prarit@redhat.com> wrote:
> The policy->initialized value can be modified from several cpus concurrently if
> !CPUFREQ_HAVE_GOVERNOR_PER_POLICY.  This leads to a situation where a
> governor maybe switched out even though the governor->initialized is greater
> than one.  It must be switched to atomic_t and protected with a mutex to
> make sure that future read/writes obtain the correct data.

Can you show a sequence of events to demonstrate the race you are talking
about? As far as I can see, there are no races :)
