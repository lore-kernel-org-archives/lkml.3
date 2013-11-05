Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3KESlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:41:16 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:58309 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3KESlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:41:14 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-fc-52793bc93f71
Message-id: <52793BC6.1080208@samsung.com>
Date: Tue, 05 Nov 2013 11:41:10 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: pavel@ucw.cz, len.brown@intel.com, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] power: Add legacy pm ops usage warning
References: <1383318424-4072-1-git-send-email-shuah.kh@samsung.com>
 <7710681.pPuGuuagq2@vostro.rjw.lan>
In-reply-to: <7710681.pPuGuuagq2@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9hX92T1pVBBo0HxS2aF69ns5g1ZS+T
	xeVdc9gsPvceYbS4e+oom8WZ05dYLb7+dHBg99g56y67x+I9L5k89s9dw+6x5Wo7i8eK1d/Z
	PT5vkgtgi+KySUnNySxLLdK3S+DK2Nx4nqXgElfF0ZkPmBsYd3B0MXJySAiYSHycuIgVwhaT
	uHBvPVsXIxeHkMAyRom5t5YxQTi9TBKvdrxmhnA2MkrM3/KAEaSFV0BL4tXhBcwgNouAqsTm
	jXfYQGw2AXWJz693sIPYQgJyEk1LVoPViApESBxd/YwVoldQ4sfkeywgtoiAtsTcnlNgC5gF
	tjJKPJjzEqxIWMBaYsK+fSwQgzIlug8vA1vAKWAgMeflajCbWcBM4lHLOmYIW15i85q3zBD1
	yhJ/Lp8CeoED6DdFie2rrSYwisxCsnoWku5ZSLoXMDKvYhQrLU4uKE5KT60w1itOzC0uzUvX
	S87P3cQIiamaHYz3vtocYhTgYFTi4U2QrwwSYk0sK67MPcQowcGsJMJ7XgcoxJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgTHzz/q59TPqAuZMNNrdaRY7laHncs9MgYcNYZqaxmaBj30eh0xYtupJ
	6bJJUZuPquhM++9hYH7om4vUnLMC+xqtnaY4upv9UVvz/tS3gycXzv7MFLyv65Z3gHgTB1tE
	XuaO5Zz7X0h/ZPVtWP/pzt6M9QmTZRJbJr9X7I4si/5wMc37CetF/UlKLMUZiYZazEXFiQBS
	tjcehwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 05:04 PM, Rafael J. Wysocki wrote:
> On Friday, November 01, 2013 09:07:04 AM Shuah Khan wrote:
>> Add legacy pm_ops usage checks to device_pm_add() when a device gets added
>> to PM core's list of active devices. If legacy pm_ops usage is found at its
>> class, bus, driver level, print warning message to indicate the driver code
>> needs updating to use dev pm ops interfaces. This will help serve as a way
>> to track drivers that still use legacy pm ops and fix them.
>
> I think it would be much better to do these checks during bus type, class or
> driver registration, because if you register a bus type with legacy PM, for
> example, the check in device_pm_add() will trigger for all devices with that
> bus type.
>
> Thanks!

Rafael,

Correct. device_pm_add() triggers for all devices that use the driver. 
On the other hand, the check is done only when the device gets added to 
the pm core. I do like that part.

I am testing with adding checks driver_register() to look for suspend at 
bus level. I am not seeing the same set of drivers I saw with the check 
in device_pm_add(), which is puzzling. I am working on testing still. 
Keep you posted.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
