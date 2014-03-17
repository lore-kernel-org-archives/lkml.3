Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaCQDNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 23:13:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52654 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbaCQDNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 23:13:45 -0400
Message-ID: <53266854.5080605@huawei.com>
Date: Mon, 17 Mar 2014 11:13:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] kmemleak: allow freeing internal objects after disabling
 kmemleak
References: <53215492.40701@huawei.com> <20140313121459.GJ30339@arm.com>
In-Reply-To: <20140313121459.GJ30339@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/13 20:14, Catalin Marinas wrote:
> On Thu, Mar 13, 2014 at 06:47:46AM +0000, Li Zefan wrote:
>> +Freeing kmemleak internal objects
>> +---------------------------------
>> +
>> +To allow access to previosuly found memory leaks even when an error fatal
>> +to kmemleak happens, internal kmemleak objects won't be freed when kmemleak
>> +is disabled, and those objects may occupy a large part of physical
>> +memory.
>> +
>> +If you want to make sure they're freed before disabling kmemleak:
>> +
>> +  # echo scan=off > /sys/kernel/debug/kmemleak
>> +  # echo off > /sys/kernel/debug/kmemleak
> 
> I would actually change the code to do a stop_scan_thread() as part of
> the "off" handling so that scan=off is not required (we can't put it as
> part of the kmemleak_disable because we need scan_mutex held).
> 

Sounds reasonable.

