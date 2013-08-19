Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab3HSSCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:02:30 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:47832 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3HSSC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:02:27 -0400
X-AuditID: cbfec37d-b7f036d000004805-06-52125db178a3
Message-id: <52125DA9.3090601@samsung.com>
Date: Mon, 19 Aug 2013 12:02:17 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Subject: Re: [ 00/34] 3.4.59-stable review
References: <20130818203259.653403173@linuxfoundation.org>
In-reply-to: <20130818203259.653403173@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX92NsUJBBvs2W1jMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWx6ZNywQ2titcHf7A2ME5R6WLk5JAQMJHYPXcbG4QtJnHh3nogm4tDSGAZo0TLg6ks
	EE4vk8S58/fAqoQENjFKnF/EAWLzCmhJHJnxjxnEZhFQldh65BsriM0moC7x+fUOdoh6OYmm
	JauBajg4RAUiJI4u14RoFZT4MfkeC4gtImAs0X92FjvILmaBdYwSq989AZspDDT/659XUHut
	JO5fegfWwClgLXH0/Wew+cxA9spJ2xghbHmJzWveMkPUK0v8uXyKCWSvhICixPbVVhMYRWYh
	WT0LSfcsJN0LGJlXMYqVFicXFCelp1aY6BUn5haX5qXrJefnbmKExEvtDsb7X20OMQpwMCrx
	8BooCAUJsSaWFVfmHmKU4GBWEuH9yg4U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwCglbOGfIWSq
	w/ZOoicjQPf9p7q7sQVaogKz5uu0Lm21Zen0WJUzc4OCyYQD/8/dXb+Le42clGui/Ldtyx5e
	etYm883lnPWT5fv7mCaZil2oTJdepM0TdbhM4oJt7hKLV3FfVk3+uaerY++x+EPfdl/Litko
	5CYnYft939N3Vvfj7vxZcWHxF1klluKMREMt5qLiRACc2gLGdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 02:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.59 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Note, there are a number of "build fixes" in this round, in the quest to
> get all arches building properly to be able to track future regressions
> easier.  Many thanks to Guenter Roeck and Geert Uytterhoeven for their
> work in doing this.
>
> Responses should be made by Tue Aug 20 20:32:48 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.59-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Greg,

This release is not looking good on one of test systems. Bluetooth is 
not recognized and wireless doesn't work. I am going to start bisect and 
giving you a head-up. The following new dmesg -l crit regression messages:

CPU2: Package power limit notification (total events = 1)
CPU3: Package power limit notification (total events = 1)
CPU0: Package power limit notification (total events = 1)
CPU1: Package power limit notification (total events = 1)

and the following traces in dmesg:
[  124.802169] init: udevtrigger post-stop process (353) terminated with 
status 1
[  243.439212] INFO: task crda:723 blocked for more than 120 seconds.
[  243.439220] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  243.439227] crda            D ffff88041f253940     0   723    362 
0x00000004
[  243.439237]  ffff8803fbde59d8 0000000000000082 ffff880404a4dbc0 
ffff8803fbde5fd8
[  243.439248]  ffff8803fbde5fd8 ffff8803fbde5fd8 ffff8803eca2c4d0 
ffff880404a4dbc0
[  243.439257]  ffff880404a4dbc0 ffffffff81caa2a0 ffff880404a4dbc0 
ffffffff81caa2a4
[  243.439266] Call Trace:
[  243.439283]  [<ffffffff816681f9>] schedule+0x29/0x70
[  243.439292]  [<ffffffff816684be>] schedule_preempt_disabled+0xe/0x10
[  243.439301]  [<ffffffff81666fa7>] __mutex_lock_slowpath+0xd7/0x150
[  243.439312]  [<ffffffff8158498e>] ? genl_rcv_msg+0x16e/0x2d0
[  243.439321]  [<ffffffff81666a7a>] mutex_lock+0x2a/0x50
[  243.439328]  [<ffffffff815847d5>] genl_lock+0x15/0x20
[  243.439335]  [<ffffffff815855fc>] ctrl_dumpfamily+0x12c/0x140
[  243.439343]  [<ffffffff81581c53>] netlink_dump+0x73/0x1e0
[  243.439350]  [<ffffffff815821d8>] netlink_recvmsg+0x338/0x430
[  243.439358]  [<ffffffff8154555d>] sock_recvmsg+0xfd/0x130
[  243.439371]  [<ffffffff81172a93>] ? __mem_cgroup_commit_charge+0xb3/0x2f0
[  243.439382]  [<ffffffff8114a78d>] ? page_add_new_anon_rmap+0xcd/0xf0
[  243.439389]  [<ffffffff8154692a>] ? move_addr_to_kernel+0x5a/0xc0
[  243.439399]  [<ffffffff815521a6>] ? verify_iovec+0x56/0xd0
[  243.439406]  [<ffffffff81545073>] ___sys_recvmsg+0x143/0x2d0
[  243.439414]  [<ffffffff81141349>] ? handle_mm_fault+0x259/0x320
[  243.439424]  [<ffffffff8154420c>] ? move_addr_to_user+0xbc/0xe0
[  243.439431]  [<ffffffff8154715c>] ? sys_getsockname+0xdc/0xf0
[  243.439437]  [<ffffffff81547ae9>] __sys_recvmsg+0x49/0x90
[  243.439444]  [<ffffffff81547b42>] sys_recvmsg+0x12/0x30
[  243.439455]  [<ffffffff816712e9>] system_call_fastpath+0x16/0x1b
[  243.439463] INFO: task NetworkManager:879 blocked for more than 120 
seconds.
[  243.439468] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  243.439473] NetworkManager  D ffff88041f293940     0   879      1 
0x00000000
[  243.439481]  ffff8804065c1a08 0000000000000082 ffff8803ecbedbc0 
ffff8804065c1fd8
[  243.439490]  ffff8804065c1fd8 ffff8804065c1fd8 ffff880408d796f0 
ffff8803ecbedbc0
[  243.439498]  ffff8804065c1ab8 ffffffff81caa2a0 ffff8803ecbedbc0 
ffffffff81caa2a4
[  243.439506] Call Trace:
[  243.439514]  [<ffffffff816681f9>] schedule+0x29/0x70
[  243.439522]  [<ffffffff816684be>] schedule_preempt_disabled+0xe/0x10
[  243.439530]  [<ffffffff81666fa7>] __mutex_lock_slowpath+0xd7/0x150
[  243.439539]  [<ffffffff81666a7a>] mutex_lock+0x2a/0x50
[  243.439546]  [<ffffffff815847d5>] genl_lock+0x15/0x20
[  243.439553]  [<ffffffff815847f6>] genl_rcv+0x16/0x40
[  243.439560]  [<ffffffff81583d1d>] netlink_unicast+0x19d/0x1f0
[  243.439567]  [<ffffffff8158404a>] netlink_sendmsg+0x2da/0x390
[  243.439574]  [<ffffffff815456e8>] sock_sendmsg+0xf8/0x130
[  243.439582]  [<ffffffff8154692a>] ? move_addr_to_kernel+0x5a/0xc0
[  243.439590]  [<ffffffff815521a6>] ? verify_iovec+0x56/0xd0
[  243.439597]  [<ffffffff81545b9e>] ___sys_sendmsg+0x41e/0x430
[  243.439607]  [<ffffffff8107e733>] ? __wake_up+0x53/0x70
[  243.439614]  [<ffffffff81582b43>] ? netlink_table_ungrab+0x33/0x40
[  243.439623]  [<ffffffff8154420c>] ? move_addr_to_user+0xbc/0xe0
[  243.439629]  [<ffffffff81547115>] ? sys_getsockname+0x95/0xf0
[  243.439636]  [<ffffffff81547869>] __sys_sendmsg+0x49/0x90
[  243.439643]  [<ffffffff815478c2>] sys_sendmsg+0x12/0x30
[  243.439651]  [<ffffffff816712e9>] system_call_fastpath+0x16/0x1b
[  363.295849] INFO: task crda:723 blocked for more than 120 seconds.
[  363.295858] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.


-- Shuah

Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
