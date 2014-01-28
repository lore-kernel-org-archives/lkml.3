Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaA1JER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:04:17 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:36579 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984AbaA1JEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:04:06 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52E77282.4030303@ladisch.de>
Date: Tue, 28 Jan 2014 10:04:02 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Network Nut <sillystack@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: WaitForMultipleObjects/etc. In Kernel
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com>
In-Reply-To: <00d001cf1b99$026407d0$072c1770$@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network Nut wrote:
> 5. I can simulate system-global named mutex using shared-memory for
> underlying state of mutex (POCO NamedMutex)
> 6. I can get named semaphore using POSIX sem_create
>
> It seems that the remaining problem is to get named mutex and named
> semaphore to be accessible by file-descriptor.

Forget about the POSIX stuff.  You can implement a mutex by using
an eventfd that has the value 1 in the unlocked state; a read locks,
a write of 1 unlocks.  You can implement a semaphore by using an eventfd
with EFD_SEMAPHORE.


And I should note that it is a common pattern to start a bunch of other
processes from a helper process; this not only allows inheriting file
descriptors, but also makes monitoring these processes easier from the
parent.  Do all of your processes really need to be started
independently?


>>> "The timeout argument specifies the minimum number of milliseconds
>>>        that epoll_wait() will block."
>>>
>>> I think the word "minimum" should be "maximum".
>>
>> This sentence was copied from the poll(2) man page, where the previous
>> sentence says "poll() blocks until one of the events occurs".  So the word
>> "block" implies that no event has occured.
>
> So that means that it is a bug, right? Or?

The purpose of a man page is certainly not to confuse its readers.  I'd
guess the maintainer would be happy about an improved wording.


Regards,
Clemens
