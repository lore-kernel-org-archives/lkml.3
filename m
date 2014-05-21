Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbaEUJyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:54:49 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:56460 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaEUJys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:54:48 -0400
MIME-Version: 1.0
In-Reply-To: <537C7680.7050305@arm.com>
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>
	<ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org>
	<537C7348.7060202@arm.com>
	<CAKohpo=F5gSPvVSAX=qePnudxiuKWLKGTZy8vd80=MJxESWJZQ@mail.gmail.com>
	<537C7680.7050305@arm.com>
Date: Wed, 21 May 2014 15:24:47 +0530
Message-ID: <CAKohpom_1cwXLM0FxkwtY_h3harjZ=XQfZgwtwoN4QDgs_pqQw@mail.gmail.com>
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 15:18, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> Why do we need to return anything? Let that function have return type
>> 'void'?
>
>
> Hmm, don't we still need to throw error if DT has invalid OPP ?
> It doesn't may sense to me if no errors is returned and still CPUFreq fails
> later.

I wasn't sure if we should fail CPU's registration if it had bad OPPs.
Maybe just print a good message and go ahead. CPU is usable atleast :)

>> Also would it make sense to move this into it as well?
>>
>> cpu->dev.of_node = of_get_cpu_node(num, NULL);
>>
>
> I don't quite understand what you mean here ?

This piece of code was added by you earlier to register_cpu(). As this was
also DT specific, should I move this as well to the new routine we are creating?
