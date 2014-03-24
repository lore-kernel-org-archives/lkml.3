Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaCXGT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:19:29 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53659 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaCXGT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140321110559.GB13596@arm.com>
References: <cover.1395379422.git.viresh.kumar@linaro.org>
	<f6116069b730c0c3a74ff627fa818b98dc4f1491.1395379422.git.viresh.kumar@linaro.org>
	<532BEE64.3090501@linux.vnet.ibm.com>
	<CAKohpom8ZHXxVmuSHYL5nyZzNrK8EFNVdx5XJdJxiHWPb13aeg@mail.gmail.com>
	<532BFB77.5060107@linux.vnet.ibm.com>
	<CAKohpomY4xf4tOFTGt-ykE7sUi4ks7vW5qp8ytgopm6CiY9QRg@mail.gmail.com>
	<20140321110559.GB13596@arm.com>
Date: Mon, 24 Mar 2014 11:49:26 +0530
Message-ID: <CAKohpomnGrfmLPJS17KnpZfqCXbvZ5S6KFDikzpqn80TFGwt5w@mail.gmail.com>
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

On 21 March 2014 16:35, Catalin Marinas <catalin.marinas@arm.com> wrote:
> The above sequence doesn't say much. As rmk said, the compiler wouldn't
> reorder the transition_ongoing write before the function call. I think
> most architectures (not sure about Alpha) don't do speculative stores,
> so hardware wouldn't reorder them either. However, other stores inside
> the cpufreq_notify_post_transition() could be reordered after
> transition_ongoing store. The same for memory accesses after the
> transition_ongoing update, they could be reordered before.

I got confused again. If we see what cpufreq_notify_post_transition() does:
Just calling a list of routines from a notifiers chain. And going by the above
statements from you, we aren't going to reorder this with function calls or
a branch instructions.

And even if for some reason, there is a bit of reorder, it doesn't look harmless
at all to me.

We are more concerned about serialization of frequency translations here. And
it still looks to me like we don't really need a barrier at all..

Probably we can keep it as is for now and maybe later add a barrier if required.
