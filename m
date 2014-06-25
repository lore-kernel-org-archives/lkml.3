Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaFYUPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:15:47 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:43028 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaFYUPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:44 -0400
X-AuditID: cbfec37d-b7fbf6d000005712-fc-53ab2deec290
Message-id: <53AB2DE4.8030804@samsung.com>
Date: Wed, 25 Jun 2014 14:15:32 -0600
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
In-reply-to: <1403726744.2581.3.camel@buesod1.americas.hpqcorp.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.216]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX913uquDDdr/6VrMWb+GzeL36l42
	iyX3hS2aF69ns7i8aw6bA6vHrIZeNo9d23YyeZyY8ZvFY//cNewenzfJBbBGcdmkpOZklqUW
	6dslcGUsPHGfreApd8Xkp5eZGxgPcnYxcnJICJhINE39wwhhi0lcuLeerYuRi0NIYBmjxOrv
	N9khnF4miX8b34BVCQlsY5S4uc4WxOYV0JJ4NXURC4jNIqAqcWX2SiYQm01AXeLz6x3sEPVy
	Ek1LVjOD2KICERIH+p6xQvQKSvyYfA+sV0RATeLl8XWMIMuYBWYwSrzsvwJWJCwQInHr7HwW
	iEG1EisXbASzOQWcJVr/dYMtYBYwk3jUso4ZwpaX2LzmLTNEvbLEn8unmCBeU5aYsvEd0wRG
	kVlIds9C0j4LSfsCRuZVjGKlxckFxUnpqRUmesWJucWleel6yfm5mxghUVO7g/H+V5tDjAIc
	jEo8vB8erwoWYk0sK67MPcQowcGsJML7/i9QiDclsbIqtSg/vqg0J7X4ECMTB6dUA+PCjGNz
	RJUmHF/d+eZtWYJ0/Mf/OvEzw6Kr2Yui2tREmObOjdRr1NOY0fp4vlmE1YKAA/f0dn64/Y8h
	w/Mm78M+59cTF3Ffbetc0i5pu3SSNP+qtHvr0hSzPTL23DfhtStzcl+r93Trm68zn+nGNDHN
	W8E8fcPD1oyIwjufLmhG1RusurNl4WwlluKMREMt5qLiRACGX/w5eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 02:05 PM, Davidlohr Bueso wrote:
> On Wed, 2014-06-25 at 13:40 -0600, Shuah Khan wrote:
>> The test fails in the middle when it is not run as root while
>> accessing /proc/sys/kernel/msg_next_id. Changed it to check
>> for root at the beginning of the test. Also added messages
>> to indicate start and test pass status.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   tools/testing/selftests/ipc/msgque.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
>> index aa290c0..30c627a 100644
>> --- a/tools/testing/selftests/ipc/msgque.c
>> +++ b/tools/testing/selftests/ipc/msgque.c
>> @@ -193,6 +193,12 @@ int main(int argc, char **argv)
>>   	int msg, pid, err;
>>   	struct msgque_data msgque;
>>
>> +	if (getuid() != 0) {
>> +		fprintf(stderr, "Please run the test as root - Exiting.\n");
>> +		exit(1);
>> +	}
>
> Please use err(3).

I will make this printf to be consistent with the rest of the
printfs in this file.

>
>> +	printf("Starting ipc tests:\n");
>
> This is unnecessary and adds nothing to the program.

The reason for doing this is it becomes easier to parse when this test
is run as part of run_tests at the top level:

make -C tools/testing/selftests run_tests

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
