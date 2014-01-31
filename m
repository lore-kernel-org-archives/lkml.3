Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbaAaRFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:05:06 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58830 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbaAaRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:05:04 -0500
Message-ID: <52EBD7BC.5020704@gmail.com>
Date: Fri, 31 Jan 2014 12:05:00 -0500
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Network Nut <sillystack@gmail.com>,
        "'Clemens Ladisch'" <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: WaitForMultipleObjects/etc. In Kernel
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com> <52E77282.4030303@ladisch.de> <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com> <95b6e508-1358-4f01-9687-344e25bd4b2b@email.android.com> <00f201cf1e15$f134ce70$d39e6b50$@gmail.com>
In-Reply-To: <00f201cf1e15$f134ce70$d39e6b50$@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/30/2014 06:49 PM, Network Nut wrote:
>> -----Original Message-----
>> From: Clemens Ladisch [mailto:clemens@ladisch.de]
>> Sent: Wednesday, January 29, 2014 2:31 AM
>> To: Network Nut
>> Cc: linux-kernel@vger.kernel.org
>> Subject: RE: WaitForMultipleObjects/etc. In Kernel
>>
>> Network Nut wrote:
>>> I was looking at POSIX because it allows naming of the primitives.
>>
>> Linux uses two orthogonal mechanisms for synchronization primitives and for
>> naming/sharing.
>>
>>> I need to epoll_wait on inter-process {mutex, event, semaphore}.
>>
>> Use eventfd.
>>
>>> I need to reference inter-process {mutex, event, semaphore}, each
>>> identified by string, if feasible.
>>
>> Send the fd through a Unix domain socket.
> 
> Hi Again,
> 
> I was thinking that, rather than as for specifics, I should present my general problem, and ask how long-time Linux experts would solve it.
> 
> I have a master process M, that executes continually, from the birth to death of user-session.
> 
> I have many (distinct) processes that will be launched, and these processes, P1, P2, ...Pn, expect to see that M is executing. These processes:
> 
> 1. expect to have access to a shared-memory section that already exists because M created it
> 2. expect to use a semaphore that already exists because M created it
> 3. expect to use a mutex that exists because M created it
> 
> P1, P2, ...Pn all know the path of image on disk of M. They are also permitted to maintain a fixed string that can be used to "get at" the mutex and semaphore.
> 
> How would P1, P2, ...Pn get at the semaphore that M created?
> 
> Please note that M cannot have any prior knowledge at all of P1, P2, ...Pn. P1...etc. must initiate  communication with M.
> 
> [I don't want to misuse/abuse linux-kernel with my personal questions, so if there is a more appropriate group, please let me know.]
> 
> Regards,
> 
> -Net
Assuming that you're porting to mainline distributions (and not embedded
devices), named SHM segments are accessible (providing the accessing
process has correct permissions) under /dev/shm.  You just need to make
sure that you create the segment with the right permissions for the
other processes to access it.
