Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030AbaCVDsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 23:48:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62082 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaCVDsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 23:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140321180723.GM13596@arm.com>
References: <cover.1395379422.git.viresh.kumar@linaro.org>
	<f6116069b730c0c3a74ff627fa818b98dc4f1491.1395379422.git.viresh.kumar@linaro.org>
	<532BEE64.3090501@linux.vnet.ibm.com>
	<CAKohpom8ZHXxVmuSHYL5nyZzNrK8EFNVdx5XJdJxiHWPb13aeg@mail.gmail.com>
	<532BFB77.5060107@linux.vnet.ibm.com>
	<CAKohpomY4xf4tOFTGt-ykE7sUi4ks7vW5qp8ytgopm6CiY9QRg@mail.gmail.com>
	<20140321110559.GB13596@arm.com>
	<532C2160.4030909@linux.vnet.ibm.com>
	<20140321180723.GM13596@arm.com>
Date: Sat, 22 Mar 2014 09:18:37 +0530
Message-ID: <CAKohpokYbnt0Yv2txN6qfHcdeaLeE5owsMWsTsKbz7cv63S2bQ@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] cpufreq: Make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2014 23:37, Catalin Marinas <catalin.marinas@arm.com> wrote:
> smp_mb() is all about relative ordering. So if you want memory accesses
> in post_transition() to be visible to other observers before
> transition_ongoing = false, you also need to make sure that the readers
> of transition_ongoing have a barrier before subsequent memory accesses.

I don't think this is a requirement in our case. We are just trying to serialize
frequency transitions here and just want to make sure that second one
start after first one is over. And so this query.

> OK, I start to get it. Is there a risk of missing a wake_up event? E.g.
> one thread waking up earlier, noticing that transition is in progress
> and waiting indefinitely?

I don't think so. The only requirement is that second thread wakes up
after this variable is set to false.
