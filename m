Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbbAVLVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:21:53 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:56885 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbbAVLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:21:51 -0500
Message-ID: <54C0DD4F.7030807@linaro.org>
Date: Thu, 22 Jan 2015 11:21:51 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>
Subject: Re: [PATCH 3.19-rc2 v14 0/7] arm: Implement arch_trigger_all_cpu_backtrace
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>	<1421144818-14036-1-git-send-email-daniel.thompson@linaro.org>	<54BE2D15.9080606@linaro.org>	<54BEC04D.1050402@codeaurora.org>	<54BF83C9.5060300@linaro.org> <20150121080612.6569ab81@gandalf.local.home> <54BFAE3F.7000300@linaro.org>
In-Reply-To: <54BFAE3F.7000300@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/15 13:48, Daniel Thompson wrote:
> On 21/01/15 13:06, Steven Rostedt wrote:
>> On Wed, 21 Jan 2015 10:47:37 +0000
>> Daniel Thompson <daniel.thompson@linaro.org> wrote:
>>
>>
>>>> With this patchset, is it possible to call sched_clock() from within NMI
>>>> context? I ask because the generic sched_clock() code is not NMI safe
>>
>> That's not good. Better not run function tracing, as that could trace
>> functions in NMI context (I depend on that it does), and it uses
>> sched_clock() as the default clock.
> 
> I think sched_clock is unsafe as in "may sometimes give the wrong value"
> rather than "can lock up arbitrarily".  Thus the impact is unlikely to
> be harmful enough to want to avoid tracing altogether.

Just to update the record...

The above paragraph is wrong in every possible way. It is a livelock
(and I'm working on it).



> It would require special care be taken when interpreting the timestamps
> however. Also since update_sched_clock() is a notrace function its very
> hard to figure out when timestamps are at risk.
> 
> Anyhow, the fix doesn't seem that hard. I can take a look.
> 
> 
> Daniel.
> 

