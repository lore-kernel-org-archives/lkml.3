Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaDWF26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:28:58 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38874 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaDWF24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:28:56 -0400
Message-ID: <53574F94.4060402@gmail.com>
Date: Wed, 23 Apr 2014 07:28:52 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: mtk.manpages@gmail.com, Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH 5/4] ipc,shm: minor cleanups
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>	 <1398221636.6345.9.camel@buesod1.americas.hpqcorp.net>	 <53574AA5.1060205@gmail.com> <1398230745.27667.2.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1398230745.27667.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 07:25 AM, Davidlohr Bueso wrote:
> On Wed, 2014-04-23 at 07:07 +0200, Michael Kerrisk (man-pages) wrote:
>> On 04/23/2014 04:53 AM, Davidlohr Bueso wrote:
>>> -  Breakup long function names/args.
>>> -  Cleaup variable declaration.
>>> -  s/current->mm/mm
>>>
>>> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
>>> ---
>>>  ipc/shm.c | 40 +++++++++++++++++-----------------------
>>>  1 file changed, 17 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/ipc/shm.c b/ipc/shm.c
>>> index f000696..584d02e 100644
>>> --- a/ipc/shm.c
>>> +++ b/ipc/shm.c
>>> @@ -480,15 +480,13 @@ static const struct vm_operations_struct shm_vm_ops = {
>>>  static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>>>  {
>>>  	key_t key = params->key;
>>> -	int shmflg = params->flg;
>>> +	int id, error, shmflg = params->flg;
>>
>> It's largely a matter of taste (and I may be in a minority), and I know
>> there's certainly precedent in the kernel code, but I don't much like the 
>> style of mixing variable declarations that have initializers, with other
>> unrelated declarations (e.g., variables without initializers). What is 
>> the gain? One less line of text? That's (IMO) more than offset by the 
>> small loss of readability.
> 
> Yes, it's taste. And yes, your in the minority, at least in many core
> kernel components and ipc.

I figured so. Just giving the minority a small voice ;-).


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
