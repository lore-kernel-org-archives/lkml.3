Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3CVDjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:39:02 -0400
Received: from shelob.surriel.com ([74.92.59.67]:39142 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3CVDjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:39:00 -0400
Message-ID: <514BD24C.3080902@surriel.com>
Date: Thu, 21 Mar 2013 23:38:52 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Hurley <peter@hurleysoftware.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org> <1363902605.4488.33.camel@thor.lan> <20130321150127.5263c56d2b5e549f76034342@linux-foundation.org>
In-Reply-To: <20130321150127.5263c56d2b5e549f76034342@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 06:01 PM, Andrew Morton wrote:
> On Thu, 21 Mar 2013 17:50:05 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:
>
>> On Thu, 2013-03-21 at 14:10 -0700, Andrew Morton wrote:
>>> On Wed, 20 Mar 2013 15:55:30 -0400 Rik van Riel <riel@surriel.com> wrote:
>>>
>>>> This series makes the sysv semaphore code more scalable,
>>>> by reducing the time the semaphore lock is held, and making
>>>> the locking more scalable for semaphore arrays with multiple
>>>> semaphores.
>>>>
>>>> The first four patches were written by Davidlohr Buesso, and
>>>> reduce the hold time of the semaphore lock.
>>>>
>>>> The last three patches change the sysv semaphore code locking
>>>> to be more fine grained, providing a performance boost when
>>>> multiple semaphores in a semaphore array are being manipulated
>>>> simultaneously.
>>>
>>> These patches conflict pretty badly with Peter's:
>>
>> On one point I'm a little confused: my series has been in linux-next for
>> a while. On what tree is this series based?
>
> It'll be based on mainline.  People often forget to peek into
> linux-next when preparing patches.  In the great majority of cases
> that's OK.  Occasionally, we lose...

I'll be happy to rebase the series onto linux-next, to make
merging easier for you.

-- 
All rights reversed.
