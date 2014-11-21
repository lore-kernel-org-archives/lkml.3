Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbaKUGAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:00:45 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57058 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaKUGAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:00:44 -0500
Message-ID: <546ED507.1020503@gmail.com>
Date: Fri, 21 Nov 2014 11:30:39 +0530
From: Victor Ascroft <victorascroft@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mason <mpeg.blue@free.fr>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Looking for good references for ARM driver development
References: <546C920A.7060800@free.fr> <546CCBF6.7070607@gmail.com> <546E600F.8020704@free.fr>
In-Reply-To: <546E600F.8020704@free.fr>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 21 November 2014 03:11 AM, Mason wrote:
> On 19/11/2014 17:57, Victor Ascroft wrote:
>
>> On 11/19/2014 06:20 PM, Mason wrote:
>>
>>> Are there more recent technical references, as good as LDD3, that
>>> cover "modern" aspects of kernel development?
>> The LDD3 is one of the best there is. A fourth edition is supposed
>> to come out sometime next year.
>> http://www.amazon.com/Linux-Device-Drivers-Jessica-McKellar/dp/1449371612
> That's the best news I've heard this week!
> Hope Jonathan gets well and lives happily ever after.
>
>>> How do I "leave device registration for the system infrastructure"?
>>> Where should I put that code?
>>> Is it a good idea to separate device registration and driver registration
>>> in the case of a SoC, where the device is embedded in the SoC and is not
>>> "hot-plugged" (or anything-plugged for that matter, it's just "there").
>> For understanding this you need to understand how the platform infrastructure
>> works and why is it used.
>> http://lwn.net/Articles/448499/
>> http://lwn.net/Articles/448502/
>> and go through some of the relevant drivers.
> More of Jon's (great) work ;-)
> Will definitely read these articles carefully.
>
>>> 3) Why is the function used to "destroy a platform device" named
>>> platform_device_put? Why put?
>>> Put on a list of things to destroy at a later time?
>> This should be more clear once you go through LDD3.
> I'm coming up empty.
> AFAICT, it's unrelated to the _put_user* family of functions.
> I see that it has something to do with ref count decrement.
> [more reading...]
> Something about kref.
> https://lwn.net/Articles/336224/
>
> They mention "put" but not *why* it's called "put".
> Is it related to Dijkstra's P and V for semaphores?
> https://cs.nyu.edu/~yap/classes/os/resources/origin_of_PV.html
> Still confused...
It has been quiet a while since I read LDD3, but, I remember this information
being somewhere in it or may be I am wrong. Not aware if these are related to
the P and V concept for semaphores.

Hmm.. You surprised me, I was not aware of put_user etc. myself. Never seen
them anywhere. I have only used and seen copy_(to/from)_user or may be it's
just that I have not worked, where these are used. I guess these _put_user family
of functions, do not carry out any kind of verification.

Yes, you are right. The platform_device_put has got to with the reference count.
platform_device_put in turn calls put_device and which in turn calls kobject_put.
The reference count for the kobject is decremented. When the reference count
reaches 0 for the kobject, kobject_cleanup is called to free the resources.

You will find good explanation of all this, the Chapter 14 Linux Device Model  of
LDD3. That is one of the best chapters to read in that book.

-Regards

>
> Regards.

