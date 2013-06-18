Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3FROzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:55:04 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:15431 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3FROzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:55:01 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-3a-51c074c35e6a
From: Shuah Khan <shuah.kh@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Thread-topic: [PATCHv v3] power: Include additional information in
 pm_print_times
Thread-index: AQHOa5INUOX6+S75906ZF4yA9Bsfdg==
Date: Tue, 18 Jun 2013 14:54:57 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172A0CB@sisaex02sj>
References: <Pine.LNX.4.44L0.1306171618430.1684-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9hX93DJQcCDb6sEbFoXryezWL2/ccs
	FrOm7GWyuLxrDpvF594jjBZ3Tx1ls+hf2Mtk8fWng8WE3xfYHDg9ds66y+6xeM9LJo/9c9ew
	e3xZdY3ZY/bdH4wejxa3MHqsWP2d3ePzJrkAjigum5TUnMyy1CJ9uwSujC9vPjIXdPFULNrx
	m6WB8TpnFyMnh4SAicS5KxtZIWwxiQv31rOB2EICyxglln+w7WLkArJ7mSS2vljGApGYzyix
	e3cCiM0moC7x+fUOdhBbREBLYnPTS2aQBmaBucwSl5rng00VFgiQ+D95EgtEUbDEvF/fGCFs
	PYm1s1eDbWMRUJU40vsYrJ5XwF5iybWFrBDLfCQuNR5lBrEZga77fmoNE4jNLCAu0dx6kwXi
	agGJJXvOM0PYohIvH/8D6uUAshUltq+2gijXkli/8zhUq7bEk3cXoFYJSvyYfI9lAqPYLCRT
	ZyFpmYWkZRaSlgWMLKsYxUqLkwuKk9JTK4z1ihNzi0vz0vWS83M3MULit2YH472vNocYBTgY
	lXh4OUT2BwqxJpYVV+YeYpTgYFYS4VVIPBAoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbE5/dyi
	F4J+f5JXN8bbvbz/+WJ2Kav80f7kf1zaTO2N1pWPnTsvFM1wmfNs6RJtDflSdfuHHy+5pzx8
	LHLHPSPuQdgdHb7Tmm83Ccqvs/t+1eUo4+N9bW98rkzY9tvqsvS9A3NfbJ+zQ7bY3Ol+8pdF
	YqunsJq838PzO7psg+4GM/Ooj9Y6x2yVWIozEg21mIuKEwHOvK15vQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 02:24 PM, Alan Stern wrote:
> On Mon, 17 Jun 2013, Shuah Khan wrote:
>
>> Change __device_suspend() path to include driver name and the ops that
>> get run for a device. This additional information helps associate the
>> driver and the type of pm_ops the device uses in the suspend path very
>> quickly, which will aid in debugging problems in suspend and resume paths.
>> Changed both start and end debug messages to include pm_ops information
>> and use dev_info() instead of pr_info(). Changed the end message to include
>> parent device information and have the same format as the start message.
>>

>>
>> [  546.087069] rtc_cmos 00:05: Start: legacy bus pm ops @ 2391, parent: pnp0
>> [  546.087084] rtc_cmos 00:05: End  : legacy bus pm ops @ 2391, parent: pnp0 time(11 usecs) err(0)
>
> If you don't mind a little more bike-shedding, I suggest formatting the
> return value and time in a shorter format, like this:
>
> [  545.987650] usb 1-1: End  : type pm ops @ 68, parent: usb1 -> 0, 2184 us
>
> Alan Stern
>
>

I am leaning towards leaving it the way it is for clarity, even though 
it is a bit longer? Changing it would make it too cryptic especially 
error return.

thanks,
-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
