Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585Ab3DJAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:36:04 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44875 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762270Ab3DJAgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:36:03 -0400
X-AuditID: 9c930179-b7b2aae000000518-2c-5164b3f1ed0b
Message-ID: <5164B3F0.2030506@lge.com>
Date: Wed, 10 Apr 2013 09:36:00 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing: Check cpu file on tracing_release()
References: <1365553093-10180-1-git-send-email-namhyung@kernel.org>  <1365553093-10180-3-git-send-email-namhyung@kernel.org> <1365553863.25498.84.camel@gandalf.local.home>
In-Reply-To: <1365553863.25498.84.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

2013-04-10 오전 9:31, Steven Rostedt 쓴 글:
> On Wed, 2013-04-10 at 09:18 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>
>> It looks like tracing_release() lacks checking iter->cpu_file so that
>> closing a per_cpu trace file would attempt to close all cpu buffers.
>>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>   kernel/trace/trace.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 7270460cfe3c..0beddcb80509 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -2883,7 +2883,13 @@ static int tracing_release(struct inode *inode, struct file *file)
>>   	WARN_ON(!tr->ref);
>>   	tr->ref--;
>>
>> -	for_each_tracing_cpu(cpu) {
>> +	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
>> +		for_each_tracing_cpu(cpu) {
>> +			if (iter->buffer_iter[cpu])
>
> Only the cpu that is assigned gets buffer_iter[cpu] set. The other
> buffer_iter[cpus] will simply be ignored.

You meant iter->cpu_file != RING_BUFFER_ALL_CPUS case, right?

So why bother trying to check other cpus then?

Thanks,
Namhyung

