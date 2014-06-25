Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaFYUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:32:09 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:23204 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaFYUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:32:07 -0400
X-AuditID: cbfec37d-b7fbf6d000005712-00-53ab31c67c93
Message-id: <53AB31C3.1080309@samsung.com>
Date: Wed, 25 Jun 2014 14:32:03 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        colin.king@canonical.com, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] tools: msgque improve error handling when not running as
 root
References: <1403725210-10245-1-git-send-email-shuah.kh@samsung.com>
 <1403726744.2581.3.camel@buesod1.americas.hpqcorp.net>
 <53AB2DE4.8030804@samsung.com>
 <1403727729.2581.10.camel@buesod1.americas.hpqcorp.net>
In-reply-to: <1403727729.2581.10.camel@buesod1.americas.hpqcorp.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.216]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9hX91jhquDDXbeZreYs34Nm8Xv1b1s
	FkvuC1s0L17PZnF51xw2B1aPWQ29bB67tu1k8jgx4zeLx/65a9g9Pm+SC2CN4rJJSc3JLEst
	0rdL4Mp4Od+w4IRQxf5N9xgbGD/xdTFyckgImEjs6D3KAmGLSVy4t56ti5GLQ0hgGaPE4y/f
	mSCcXiaJF2t3Q2W2MUpsa/jLDNLCK6Alsf/4LUYQm0VAVeJP/y6wUWwC6hKfX+9gB7GFBOQk
	mpasBqsXFYiQOND3jBWiV1Dix+R7YPUiAmoSL4+vYwRZwCwwg1HiZf8VsCJhgRCJW2fns0Bs
	vsEocW77GbBJnAIuEj13l4IVMQuYSTxqWccMYctLbF7zlhlis7LEn8unmCCeU5aYsvEd0wRG
	kVlIls9C0j4LSfsCRuZVjGKlxckFxUnpqRUmesWJucWleel6yfm5mxghcVO7g/H+V5tDjAIc
	jEo8vB8erwoWYk0sK67MPcQowcGsJML7/i9QiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NQX4LG
	dd0cnWxB2aL3vHMkzyxk9uu/t10lqaLVxUPBwMyk8t23ngUPMy9cKos6m3pY7c7xKWEJH6dv
	ULxcLxCkk3LscWefQ5dYyFSnxhPX15yZy6G4+K7HV4939Xbh+/KfrCvxT422C+zQTNJ7+43p
	tlC2UE6uWojoJOlMxse/Kjmz5HjuKrEUZyQaajEXFScCAIf6Pr95AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 02:22 PM, Davidlohr Bueso wrote:
> On Wed, 2014-06-25 at 14:15 -0600, Shuah Khan wrote:
>> On 06/25/2014 02:05 PM, Davidlohr Bueso wrote:
>>> On Wed, 2014-06-25 at 13:40 -0600, Shuah Khan wrote:
>>>> The test fails in the middle when it is not run as root while
>>>> accessing /proc/sys/kernel/msg_next_id. Changed it to check
>>>> for root at the beginning of the test. Also added messages
>>>> to indicate start and test pass status.
>>>>
>>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>>> ---
>>>>    tools/testing/selftests/ipc/msgque.c | 7 +++++++
>>>>    1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
>>>> index aa290c0..30c627a 100644
>>>> --- a/tools/testing/selftests/ipc/msgque.c
>>>> +++ b/tools/testing/selftests/ipc/msgque.c
>>>> @@ -193,6 +193,12 @@ int main(int argc, char **argv)
>>>>    	int msg, pid, err;
>>>>    	struct msgque_data msgque;
>>>>
>>>> +	if (getuid() != 0) {
>>>> +		fprintf(stderr, "Please run the test as root - Exiting.\n");
>>>> +		exit(1);
>>>> +	}
>>>
>>> Please use err(3).
>>
>> I will make this printf to be consistent with the rest of the
>> printfs in this file.
>
> Can you please update the file then. err(EXIT_FAILURE, ...) is a lot
> nicer than fprintf+exit combos all over the place.

That would make sense as a separate patch and not as part of fix for
this problem.

>
>>
>>>
>>>> +	printf("Starting ipc tests:\n");
>>>
>>> This is unnecessary and adds nothing to the program.
>>
>> The reason for doing this is it becomes easier to parse when this test
>> is run as part of run_tests at the top level:
>
> Parsing reasons should not determine such things. What if I add shm, or
> semaphore tests to the ipc dir?? Then the text would be bogus. What if
> not all tests pass? There is no way of determining a percentage of
> completeness. Please do not add such things for a simple msg queue
> program as it doesn't necessarily represent ipc selftests.
>

I can drop these messages. However, I do think it would make sense
to add a summary of tests passed. Similar to what mqueue does for
example.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
