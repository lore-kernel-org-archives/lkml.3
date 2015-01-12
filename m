Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbbALXgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:36:08 -0500
Received: from er-systems.de ([46.4.18.139]:39080 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbbALXgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:36:07 -0500
Date: Tue, 13 Jan 2015 00:35:58 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To: Luis Henriques <luis.henriques@canonical.com>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.16.y-ckt stable] Linux 3.16.7-ckt4 stable review
In-Reply-To: <20150112215941.GJ2455@charon>
Message-ID: <alpine.LSU.2.11.1501130035110.20153@er-systems.de>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com> <alpine.LSU.2.11.1501122121450.16281@er-systems.de> <20150112215941.GJ2455@charon>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.98.5/19912/Mon Jan 12 12:55:27 2015 signatures 55.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015, Luis Henriques wrote:

> On Mon, Jan 12, 2015 at 09:30:45PM +0100, Thomas Voegtle wrote:
>> On Mon, 12 Jan 2015, Luis Henriques wrote:
>>
>>> This is the start of the review cycle for the Linux 3.16.7-ckt4 stable kernel.
>>>
>>> This version contains 216 new patches, summarized below.  The new patches are
>>> posted as replies to this message and also available in this git branch:
>>>
>>> http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.16.y-review;a=shortlog
>>>
>>> git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.16.y-review
>>>
>>> The review period for version 3.16.7-ckt4 will be open for the next three days.
>>> To report a problem, please reply to the relevant follow-up patch message.
>>>
>>> For more information about the Linux 3.16.y-ckt extended stable kernel version,
>>> see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .
>>
>>
>> Something is wrong with drm/i915 (I guess). I had a terrible memleak on Xorg
>> when using mplayer using more and more RAM, and then the system is swapping
>> itself to death.
>>
>> I'm using a openSUSE 13.1 (x86_64) on a Baytrail J1900 (this is Intel HD
>> Gen7).
>>
>>
>
> Thank you for reporting, Thomas.  Can you please confirm that this is
> actually a regression in 3.16.7-ckt4 (i.e., that you can't reproduce
> it in 3.16.7-ckt3)?  If so, is it possible to bisecting it?


3.16.7-ckt3 was fine for me.

I tried to revert the drm/i915 patches in the review branch, and I got 
lucky with (only) reverting cb58c663d940a "drm/i915: Disallow pin ioctl 
completely for kms drivers".

No clue, why reverting these few lines helps, but then I have no memleak.


      Thomas

