Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaANIft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:35:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58228 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaANIfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:35:47 -0500
Message-ID: <52D4F6BA.9010802@canonical.com>
Date: Tue, 14 Jan 2014 09:35:06 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Colin Cross <ccross@google.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        robdclark@gmail.com,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        daniel@ffwll.ch, Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] sched: allow try_to_wake_up to be used internally
 outside of core.c
References: <20140113122818.20574.34710.stgit@patser>	<20140113123126.20574.74329.stgit@patser> <CAMbhsRTBSzAsBke0H4cwJMUe4449KbD6cvyLuNV4ijx0L+czFw@mail.gmail.com>
In-Reply-To: <CAMbhsRTBSzAsBke0H4cwJMUe4449KbD6cvyLuNV4ijx0L+czFw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 13-01-14 19:50, Colin Cross schreef:
> On Mon, Jan 13, 2014 at 4:31 AM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> The kernel fence implementation doesn't use event queues, but needs
>> to perform the same wake up. The symbol is not exported, since the
>> fence implementation is not built as a module.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> ---
>>  include/linux/wait.h |    1 +
>>  kernel/sched/core.c  |    2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/wait.h b/include/linux/wait.h
>> index eaa00b10abaa..c54e3ef50134 100644
>> --- a/include/linux/wait.h
>> +++ b/include/linux/wait.h
>> @@ -12,6 +12,7 @@
>>  typedef struct __wait_queue wait_queue_t;
>>  typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
>>  int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
>> +int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags);
>>
>>  struct __wait_queue {
>>         unsigned int            flags;
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index a88f4a485c5e..f41d317042dd 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1578,7 +1578,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
>>   * Return: %true if @p was woken up, %false if it was already running.
>>   * or @state didn't match @p's state.
>>   */
>> -static int
>> +int
>>  try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>>  {
>>         unsigned long flags;
>>
> wake_up_state is already available in linux/sched.h, can you use that?
>
Indeed! Thanks for the catch.

~Maarten
