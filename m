Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaBQIjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:39:07 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39508 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaBQIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:39:04 -0500
MIME-Version: 1.0
In-Reply-To: <5301C605.3030205@linux.vnet.ibm.com>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
	<4772234.6D4cUIJHX4@vostro.rjw.lan>
	<CAKohpo=uPbqMcDEHYEMahRF0rCO8KYscj2nocz81_OTKyU+Tfw@mail.gmail.com>
	<5301C605.3030205@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 14:09:03 +0530
Message-ID: <CAKohpo=mQWxoKTduR8FrrB4Qz45qXQrJjSudq=FkCJtHBTbo2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 February 2014 13:49, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Quick question: Looking at cpufreq_update_policy() and cpufreq_out_of_sync(),
> I understand that if the cpufreq subsystem's notion of the current frequency
> does not match with the actual frequency of the CPU, it tries to adjust and
> notify everyone that the current frequency is so-and-so, as read from the
> hardware. Instead, why can't we simply set the frequency to the value that
> we _want_ it to be at? I mean, if cpufreq subsystem thinks it is X KHz and
> the actual frequency is Y KHz, we can as well fix the anomaly by setting the
> frequency immediately to X KHz right?
>
> The reason I ask this is that, if we follow this approach, then we can avoid
> ambiguities in dealing with the out-of-sync situation. That is, it becomes
> very straightforward to decide _what_ to do, when we detect scenarios where
> the frequency goes out of sync.

Hmm, it is just about doing all that stuff in a single line, like:
__cpufreq_driver_target(...) ??

There are few problems here:
- If we simply call above routine with X, then it will simply return as
X == policy->cur. And I don't want to hack this code in a bad way now :)

- So, probably the way it is implemented is right, as we do that the most
efficient way. We just broadcast the new freq in case there is a difference
otherwise nothing.
