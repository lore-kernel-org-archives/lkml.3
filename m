Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3DTVpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 17:45:44 -0400
Received: from yourcmc.ru ([195.24.71.121]:39309 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab3DTVpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 17:45:43 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Apr 2013 17:45:43 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 21 Apr 2013 01:38:33 +0400
From: vitalif@yourcmc.ru
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Venkatesh Pallipadi (Venki)" <venki@google.com>, <700333@bugs.debian.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
In-Reply-To: <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk>
References: <4bded8a24b0719d575f6ffa6b38aebb6@yourcmc.ru>
 <1362490501.3768.409.camel@deadeye.wl.decadent.org.uk>
 <1b81bc6219ee47a5b8e53d03e9944939@yourcmc.ru>
 <20130305203952.GZ9079@decadent.org.uk>
 <4e8c511dcfd811c0f2ab822adaf52e50@yourcmc.ru>
 <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk>
 <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru>
 <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk>
Message-ID: <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru>
User-Agent: Roundcube Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Stack trace picture is here:
>> http://vmx.yourcmc.ru/var/pics/IMG_20130306_141045.jpg
>
> Vitaliy reported that his system crashes when suspending to disk.  
> This
> was a regression from 3.2 to 3.7, and remains in 3.8.  Some details 
> of
> this system are in the bug log at <http://bugs.debian.org/700333>.
>
> The photo shows a BUG in hrtimer_interrupt() after making the
> hibernation image and while resuming the non-boot CPUs.  The HPET
> interrupt handler was called immediately after it was registered for 
> CPU
> 2 (?), before the corresponding clock_event_device was registered.
>
> Seems like an obvious race condition, but then shouldn't the HPET 
> have
> been stopped while the CPU was previously offlined?  And it's strange
> that this system apparently hits the race quite reliably.

Anyone?
