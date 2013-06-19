Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab3FSD0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:26:17 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:64112 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab3FSD0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:26:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokN_iJ5in0t3Mo68Tost0u2WT65PQtynQ7-wxGZr0LDQQ@mail.gmail.com>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com>
	<1912850.KuRKhn87Nf@vostro.rjw.lan>
	<CAFgnuDe1bUub92uE1H9Fc9U7AJCYL=WKdyDe2bg00yEr=kMEbQ@mail.gmail.com>
	<CAKohpoktu5+h0YOCtoS6sq2UP2iU+z+nYjwB6rH7cRWDAOhRSA@mail.gmail.com>
	<CAKohpokN_iJ5in0t3Mo68Tost0u2WT65PQtynQ7-wxGZr0LDQQ@mail.gmail.com>
Date: Wed, 19 Jun 2013 11:26:13 +0800
Message-ID: <CAFgnuDdN6CoLCvH6-d9YB=-jm-ESC1s__si970pa10mC3wsCdw@mail.gmail.com>
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Xiaoguang Chen <chenxg@marvell.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/19 Viresh Kumar <viresh.kumar@linaro.org>:
> On 19 June 2013 08:43, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 19 June 2013 06:50, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
>>> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
>>
>>>>> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
>>>>
>>>> Can you please tell me what the above is supposed to mean?  Is it supposed to
>>>> mean "the online of cpu3 is being run on cpu0" or something different?  If
>>>> something different, then what?

Sorry I missed this question, Let me explain it in detail
Suppose we are in such condtition, current cpufreq goveror is
userspace governor. cpu3 is offline.
and two things happen as above two cases, first thing is application
tries to change current governor to ondemand governor,
second thing is cpu0 tries to make cpu3 online which is off line
before. both of these two cases will try to stop current governor and
start a governor. if above two things interleave, unexpected behavior
will happen.


>>
>> Please read all the questions carefully. You missed this one.
>>
>> Actually you should write: Current governor is userspace, now cpu0 hot-unplugs
>> cpu3, it will **
>
> Ahh I am mistaken, you are actually bringing cpu3 back to the system. Then you
> must have mentioned earlier that cpu3 wasn't online.
