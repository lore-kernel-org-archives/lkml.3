Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaF1L4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:56:53 -0400
Received: from [119.145.14.66] ([119.145.14.66]:60037 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaF1L4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:56:51 -0400
Message-ID: <53AEAD59.5060701@huawei.com>
Date: Sat, 28 Jun 2014 19:56:09 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] time: Provide full featured jiffies_to_nsecs() function
References: <0286550@agluck-desk.sc.intel.com> <53795E3B.9000004@huawei.com> <3908561D78D1C84285E8C5FCA982C28F3280EB34@ORSMSX114.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3280EB34@ORSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.191]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.53AEAD62.004C,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 200fcdd03012f4597c87a9eaabf9ea11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/20 6:35, Luck, Tony wrote:
>> Another problem, maybe we should use get_jiffies_64() instead of jiffies
>> directly here OR we'll meet wraparound problems on 32bit system. But a
>> same problem is that the jiffies_lock is not safe in NMI context...
> 
> To quote Winnie the Pooh - "Bother".
> 
> Can someone think of a clever way to get a sane 64 bit jiffie value on
> 32-bit systems (even when we get an NMI in the middle of updating the
> 64-bit jiffie)?

Hi Tony & Steven,

I've sent a patch to solve this problem, please help to review, thanks.

	http://lkml.org/lkml/2014/6/28/41
	tracing: fix uptime overflow problem

Thanks,
	XiuQi

