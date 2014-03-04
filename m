Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaCDPck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:32:40 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38699 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaCDPci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:32:38 -0500
Message-ID: <5315F203.80602@linaro.org>
Date: Tue, 04 Mar 2014 23:32:19 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [sched/balance] 18e6296b85e: -96.9% interrupts.RES
References: <20140304130559.GA28781@localhost>
In-Reply-To: <20140304130559.GA28781@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for the testing result!

I know the problem I have. :)


On 03/04/2014 09:05 PM, Fengguang Wu wrote:
> Hi Alex,
>
> FYI, we noticed the below changes on
>
> https://github.com/alexshi/power-scheduling.git single-balance
> commit 18e6296b85ea72c81aa485653d442ad88296d475 ("sched/balance: central balance prototype")
>
> test case: snb-drag/crypto/tcrypt/2s-301-319
>
> 598143917dc5ecf  18e6296b85ea72c81aa485653
> ---------------  -------------------------
>      206307 ~ 0%     -96.9%       6337 ~ 4%  TOTAL interrupts.RES
>      506552 ~ 1%     -24.3%     383290 ~ 3%  TOTAL cpuidle.C6-SNB.usage
>       18.27 ~ 9%   +1063.5%     212.53 ~25%  TOTAL time.system_time
>           1 ~30%   +1262.5%         21 ~31%  TOTAL time.percent_of_cpu_this_job_got
>         821 ~12%     -22.3%        638 ~19%  TOTAL vmstat.system.in
>
>
>
>                                   time.system_time
>
>     400 ++-------------------------------------------------------------------+
>         |                                                                    |
>     350 ++        O         O    O                                           |
>     300 ++O  O                     O                                         |
>         O      O         O    O       O O                                    |
>     250 ++          O                          O                             |
>         |              O                          O                          |
>     200 ++                                                                   |
>         |                                  O                                 |
>     150 ++                                   O                               |
>     100 ++                                                                   |
>         |                                                                    |
>      50 ++                                                                   |
>         *.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*.*..*.*..*.*..*.*..*.*..*.*..*.*
>       0 ++-------------------------------------------------------------------+
>
>
> Thanks,
> Fengguang

