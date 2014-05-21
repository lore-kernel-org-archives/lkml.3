Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaEUJsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:48:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42418 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaEUJsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:48:46 -0400
Message-ID: <537C7680.7050305@arm.com>
Date: Wed, 21 May 2014 10:48:48 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
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
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>	<ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org>	<537C7348.7060202@arm.com> <CAKohpo=F5gSPvVSAX=qePnudxiuKWLKGTZy8vd80=MJxESWJZQ@mail.gmail.com>
In-Reply-To: <CAKohpo=F5gSPvVSAX=qePnudxiuKWLKGTZy8vd80=MJxESWJZQ@mail.gmail.com>
X-OriginalArrivalTime: 21 May 2014 09:48:44.0742 (UTC) FILETIME=[DAF79E60:01CF74D9]
X-MC-Unique: 114052110484307301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/05/14 10:41, Viresh Kumar wrote:
> On 21 May 2014 15:05, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> As Rafael mentioned it's better to have a wrapper function to hide these
>> details. You should consider the fact that of_init_opp_table returns -EINVAL
>> if
>> CONFIG_PM_OPP not defined as well as when the list is invalid in the DT.
>> IMO we can return -ENOSYS if not implemented(i.e. !CONFIG_PM_OPP)
>
> I didn't understood Rafael's comment as I couldn't figure out if he is just
> pointing to CONFIG_** or some arch specific thing..
>
> But it looks more obvious that he asked me something similar to what you
> are saying :)
>

I believe so, mainly the non-DT case, since you are checking for error, it will
end up with spurious messages as the return value is -EINVAL. Hence I was
suggesting return -ENOSYS(which means Function not implemented)

> Why do we need to return anything? Let that function have return type 'void'?

Hmm, don't we still need to throw error if DT has invalid OPP ?
It doesn't may sense to me if no errors is returned and still CPUFreq fails
later.

> Also would it make sense to move this into it as well?
>
> cpu->dev.of_node = of_get_cpu_node(num, NULL);
>

I don't quite understand what you mean here ?

Regards,
Sudeep

