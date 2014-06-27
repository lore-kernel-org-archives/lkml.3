Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaF0UAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:00:03 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:45352 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaF0T77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:59:59 -0400
X-AuditID: cbfec37a-b7f206d000005572-69-53adcd3e19a6
Message-id: <53ADCD3B.3000209@samsung.com>
Date: Fri, 27 Jun 2014 13:59:55 -0600
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
 <53ADA58D.4070307@samsung.com>
 <20140627124552.d834ecd58c416c0a2d0dae02@linux-foundation.org>
In-reply-to: <20140627124552.d834ecd58c416c0a2d0dae02@linux-foundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.209]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9hP127s2uDDba+lbSYs34Nm8WHplZm
	i5mvu5ksmhevZ7M4051rcXnXHDaLy5NWMjmwe8xuuMjisehlA4vHzll32T163rSwepyY8ZvF
	Y//cNewenzfJBbBHcdmkpOZklqUW6dslcGUsO8dR8FKs4tilX6wNjKuEuhg5OSQETCQ2bXzE
	CmGLSVy4t56ti5GLQ0hgGaPEvc1f2EASQgK9TBKL2jghEtsYJb61dYEleAW0JHpOf2LsYuTg
	YBFQlZi8qA4kzCagLvH59Q52iF45iaYlq5lBbFGBCIkDfc9YIVoFJX5MvscCYosI6Eqser6L
	GWQ+s8ABRokL33aBFQkLeEjsnfmFFWLxc0aJW0f/gnVwCnhLdDc0MYHYzALWEisnbWOEsOUl
	Nq95ywyxWVniz+VTTBCvKUtMbLzNMoFRZBaS5bOQtM9C0r6AkXkVo1hpcXJBcVJ6aoWhXnFi
	bnFpXrpecn7uJkZIbFXtYLzz1eYQowAHoxIP74e2tcFCrIllxZW5hxglOJiVRHilVwCFeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MCre4ltpLsKyKlD02uRXRSzpO+VCuD5wRMkuey38nemhwrvN
	2x9trLf2Wnlzlon5zo+e9ZV1nWtZVFLLeyR38//SyrCUa3PvMO6qVHqeJPG7r8/Yfaqdp8Hk
	3pLyqMnmlcukvr9YFWvdtXYrX/n7Za2lW99UnD/wf7EpW1xAVKvFcu7sNQ6blFiKMxINtZiL
	ihMBqAuwmosCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 01:45 PM, Andrew Morton wrote:
> On Fri, 27 Jun 2014 11:10:37 -0600 Shuah Khan <shuah.kh@samsung.com> wrote:
>
>> On 06/26/2014 03:51 PM, Andrew Morton wrote:
>>> On Thu, 26 Jun 2014 14:33:56 -0600 Shuah Khan <shuah.kh@samsung.com> wrote:
>>>
>>>> On some systems, hotplug tests could hang forever waiting for cpu and
>>>> memory to be ready to be offlined. A special hotplug target is created,
>>>> which will help run non-hotplug tests and run hotplug tests as a special
>>>> case. Individual hotplug tests can still be run as a special target
>>>> targeted for a single subsystem.
>>>
>>> This is a bit sad.  The general philosophy with selftests is that they
>>> should run to completion even if the kernel/hardware which they are
>>> testing isn't available - they should work it out for themselves.
>>>
>>> But that's obviously a problem with hotplug.  And with networking or
>>> anything else which needs external action.
>>>
>>> On the other hand, networking has loopback and the kernel supports cpu
>>> hotplug simulation via procfs.  So perhaps the cpu and memory hotplug
>>> tests should be redone so they do the plug/unplug injection themselves,
>>> so they can run without external intervention?
>>
>> Changing/running the tests in a safe mode (least possibility of hang)
>> mode is another option. This way the tests are run in normal mode with
>> reduced scope. Memory hotplug test has the ratio option and when I
>> specified low ratio 1-5%, it completed in a few seconds.
>>
>> cpu-hotplug test will require changes. I am working on a change to
>> offline a user specified # of cpus instead offlining all hotpluggable
>> cpus and then onlining them again at the end of the test.
>>
>> When all selftests are run, safe mode hotplug tests will be run.
>>
>> Does this approach sound reasonable?
>
> I don't know really.  You know more about this than I - what advantages
> does the separate-make-target approach have over this approach?
>

Currently these tests run with full range - i.e try to offline
all cpus that are hotpluggable and try to offline all memory
that is hotpluggable. This results in hangs.

Creating a separate target the way I did it in this patch excludes these
tests all together. i.e when somebody runs:

make -C tools/testing/selftests run_tests

hotplug tests don't run.

Instead, with a few changes, tests can be run with a reduced scope so
a % of the memory gets offlined as opposed to all of it and the same
thing with cpus. This way hotplug code gets tested as opposed to
being excluded in a default test run case.

However, if limited scope testing isn't useful, separate target is
better until tests can be made safe to run without hangs.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
