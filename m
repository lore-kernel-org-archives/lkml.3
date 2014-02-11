Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaBKPiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:38:51 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:60867 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:38:49 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
X-AuditID: cbfec37a-b7ef66d000004f2b-79-52fa4407ecbe
Message-id: <52FA43FF.8030303@samsung.com>
Date: Tue, 11 Feb 2014 08:38:39 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Cc: rjw@rjwysocki.net, chris@printf.net, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFT][PATCH 08/12] mmc: change cb710-mmc platform power management
 to use dev_pm_ops
References: <cover.1392040064.git.shuah.kh@samsung.com>
 <5393e4bd34e5667b7d00fa09c9d5bee0f68d659f.1392040068.git.shuah.kh@samsung.com>
 <20140210234904.GA542@rere.qmqm.pl>
In-reply-to: <20140210234904.GA542@rere.qmqm.pl>
Content-transfer-encoding: 8bit
X-Originating-IP: [105.144.34.13]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9hX112l19BBnPvmFlMuLyd0eLyrjls
	Fkf+9zNafO49wmjx7fkpRoszpy+xWnz96eDA7rFz1l12jxuvFjJ5zGrbx+ax5Wo7i8fnTXIB
	rFFcNimpOZllqUX6dglcGW9WXGMpOMBRMesoVwPjfbYuRg4OCQETiQv3PboYOYFMMYkL99YD
	hbk4hASWMUp8v36fHSTBKyAo8WPyPRYQm1nAWqJp3xVmEFtIoJdJYu2SaoiGTYwSz4/+ABvK
	K6AlcX9GAojJIqAqMekzWCubgLrE59c72CFa5SSalqwGGyMqECHx6uxEsBoRASeJQwfvMIGM
	ZBbYxijRs+wjWJGwQLLE/e5P7BC71jFKzDwFciknB6eAgcT63m5miOPkJQ5eec4CsUFZ4s/l
	U0wQnylKTPx9gXkCo8gsJP/MQvLPLCTtCxiZVzGKlRYnFxQnpadWGOoVJ+YWl+al6yXn525i
	hMRQ1Q7GO19tDjEKcDAq8fBe+PQjSIg1say4MvcQowQHs5IIr5raryAh3pTEyqrUovz4otKc
	1OJDjEwcnFINjKbGh1b+rt5jy3A9bKXbKsX9wc6/X+ZZT/moyDvz/e3WwF3vP7b5Tj2l0+Ke
	xhgX+I5h25l1ju+bF78uiJtwsNTDaePjY5sZr32N2sz843xQ+TnPl7lf1mZt9083Pq5y+8ne
	Z3dcn6hc6d7B77TA7sR9k8OXVvPc+Zn/3nzDkul2L1fZpC2wXrFIiaU4I9FQi7moOBEABMcE
	JX8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 04:49 PM, Micha³ Miros³aw wrote:
> On Mon, Feb 10, 2014 at 09:12:31AM -0700, Shuah Khan wrote:
>> Change cb710-mmc platform driver to register pm ops using dev_pm_ops instead
>> of legacy pm_ops. .pm hooks call existing legacy suspend and resume interfaces
>> by passing in the right pm state.
> [all the patch cut]
>
> Aaah, a bit mechanical - this change, isn't it?

Yes :)

>
> The suspend/resume callbacks just clears IRQ mask in the device in case it
> got undefined during sleep state. So the proper change here is to squash all
> the functions in one, and point all of the hooks to it.
>
> With the change you have my ack.
>
> BTW, you could move cb710_mmc_suspend() (or whatever you'll call it) to one
> ifdef block with cb710_mmc_dev_pm_ops.
>

It makes perfect sense to squash suspend and resume. Thanks for the 
review. Code looks lot simpler now. Will send v2 patch shortly.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
