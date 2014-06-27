Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaF0RKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:10:43 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:37240 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaF0RKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:10:42 -0400
X-AuditID: cbfec37b-b7fbe6d000006742-6f-53ada5901886
Message-id: <53ADA58D.4070307@samsung.com>
Date: Fri, 27 Jun 2014 11:10:37 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@linuxfoundation.org, keescook@chromium.org, michael@ellerman.id.au,
        fweisbec@gmail.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] tools: selftests - create a separate hotplug target
References: <1403814836-16964-1-git-send-email-shuah.kh@samsung.com>
 <20140626145106.83d8a15bfa07270b00e5d24b@linux-foundation.org>
In-reply-to: <20140626145106.83d8a15bfa07270b00e5d24b@linux-foundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.209]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9hX90JS9cGG6x9LWIxZ/0aNosPTa3M
	FjNfdzNZNC9ez2ZxpjvX4vKuOWwWlyetZHJg95jdcJHFY9HLBhaPnbPusnv0vGlh9Tgx4zeL
	x/65a9g9Pm+SC2CP4rJJSc3JLEst0rdL4Mp4euQee8FsvoqXvaYNjNu5uxg5OSQETCQuX77E
	CGGLSVy4t56ti5GLQ0hgGaPE0wX/mUESQgK9TBLX59lCJLYxSnT/fcwCkuAV0JJ49GUFWBGL
	gKrE7/8v2UFsNgF1ic+vd7BDNMtJNC1ZDVYjKhAhcaDvGStEr6DEj8n3wOaICOhKrHq+ixlk
	AbPAAUaJC992gRUJC3hI7J35hRVicyujxJ+/vWBTOQW8JWa9/sEEYjMLWEusnLSNEcKWl9i8
	5i3U2coSfy6fYoL4TVliYuNtlgmMIrOQLJ+FpH0WkvYFjMyrGMVKi5MLipPSUyuM9IoTc4tL
	89L1kvNzNzFCoqt6B+PdrzaHGAU4GJV4eD+2rQ0WYk0sK67MPcQowcGsJML7aD5QiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA2PRheMBl7SCz9xTvtDIZvBbPKqe0/7BKjazKdEfPylWrH3991eh
	xOImnbY/Ua53/JfJ3Hm/UclHIvVQacdEptNzDN+kLf4r3iNTc85s3kNnpS8B22csc03eoJAq
	obtTzO1Jl6bep3sp385UrNjU0dV79FjIR4UNAkdXP7W/dFyH36YjUn9lyQQlluKMREMt5qLi
	RACcZ7/IjAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 03:51 PM, Andrew Morton wrote:
> On Thu, 26 Jun 2014 14:33:56 -0600 Shuah Khan <shuah.kh@samsung.com> wrote:
>
>> On some systems, hotplug tests could hang forever waiting for cpu and
>> memory to be ready to be offlined. A special hotplug target is created,
>> which will help run non-hotplug tests and run hotplug tests as a special
>> case. Individual hotplug tests can still be run as a special target
>> targeted for a single subsystem.
>
> This is a bit sad.  The general philosophy with selftests is that they
> should run to completion even if the kernel/hardware which they are
> testing isn't available - they should work it out for themselves.
>
> But that's obviously a problem with hotplug.  And with networking or
> anything else which needs external action.
>
> On the other hand, networking has loopback and the kernel supports cpu
> hotplug simulation via procfs.  So perhaps the cpu and memory hotplug
> tests should be redone so they do the plug/unplug injection themselves,
> so they can run without external intervention?

Changing/running the tests in a safe mode (least possibility of hang)
mode is another option. This way the tests are run in normal mode with
reduced scope. Memory hotplug test has the ratio option and when I
specified low ratio 1-5%, it completed in a few seconds.

cpu-hotplug test will require changes. I am working on a change to
offline a user specified # of cpus instead offlining all hotpluggable
cpus and then onlining them again at the end of the test.

When all selftests are run, safe mode hotplug tests will be run.

Does this approach sound reasonable?

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
