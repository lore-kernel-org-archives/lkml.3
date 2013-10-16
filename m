Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab3JPG71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:59:27 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:37502 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3JPG7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:59:25 -0400
Message-ID: <525E37BF.4040303@onera.fr>
Date: Wed, 16 Oct 2013 08:52:47 +0200
From: Paul Chavent <Paul.Chavent@onera.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
References: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>	<20131011124720.bf38f18affa8baf0b009875a@linux-foundation.org>	<20131015104350.GI4285@enneenne.com> <20131015125545.1920ab5453136f3de5f2aa66@linux-foundation.org>
In-Reply-To: <20131015125545.1920ab5453136f3de5f2aa66@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Wed, 16 Oct 2013 08:59:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/15/2013 09:55 PM, Andrew Morton wrote:
> On Tue, 15 Oct 2013 12:43:50 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:
>
>> On Fri, Oct 11, 2013 at 12:47:20PM -0700, Andrew Morton wrote:
>>> On Fri, 11 Oct 2013 14:40:32 +0200 Paul Chavent <Paul.Chavent@onera.fr> wrote:
>>>
>>>> The PPS_FETCH ioctl is blocking still the reception of a PPS
>>>> event. But, in some case, one may immediately need the last event
>>>> date. This patch allow to get the result of PPS_FETCH if the device
>>>> has the O_NONBLOCK flag set.
>>>
>>> Are the PPS ioctls actually documented anywhere?
>>> Documentation/pps/pps.txt is silent.
>>>
>>> That's a shame, because it would be nice to have a formal description
>>> of the the PPS_FETCH semantics which leads to an understanding of why
>>> things are the way they are, how PPS_FETCH is supposed to be used, etc.
>>>
>>> Also, the presence of such documentation would permit me to bug you for
>>> not having updated it!  We need *some* channel for telling people about
>>> the driver, and updates to it.  Maybe linuxpps.org has it somewhere,
>>> but I couldn't immediately find it.
>>
>> Hi Andrew! Actually RFC 2783 doesn't use ioctls to get access to PPS
>> data but it defines some functions. LinuxPPS, that is the Linux PPS
>> implementation, uses ioctls to implement these functions.
>>
>> If you like having an idea about how these functions are implemented
>> into LinuxPPS, you can see here:
>>
>>     http://www.linuxpps.org/gitweb/?p=pps-tools;a=blob;f=timepps.h;h=d2628d2d061ea2a3623e57990d9ada62623773cf;hb=5980a044bcdb4c1d1a8b1ecff986fa63719519b3
>>
>>> Your implementation requires that the file be opened non-blocking.  But
>>> I'd have thought that adding a new and separate ioctl mode would be a
>>> cleaner and more flexible implementation - that way an app which wants
>>> both blocking and non-blocking behaviour doesn't need to open the file
>>> twice.
>>>
>>> Also, this is actually a non-backward-compatible change for any
>>> application which happened to be opening the file with O_NONBLOCK!
>>> Hopefully there aren't any such applications...
>>
>> The major application that I know using these layer is NTPD... however
>> all RFC compliant applications should not use ioctls to get access the
>> PPS data and this patch should be a "special" case.
>>
>
> Thanks, but this doesn't really address my concerns.
>
> - Where, if anywhere, is the Linux PPS API documented and how do we
>    communicate changes such as this one to kernel users?
>
> - Why require open(O_NONBLOCK) for this instead of adding a separate
>    ioctl?
>

I would also prefer the separate ioctl. As you said it, it's a bit 
annoying to switch from blocking mode to non blocking mode if we need 
both mode. But i was not sure about the preferences of the maintainer : 
(i) change the api, or (ii) change the behavior with a widely supported 
interface (O_NONBLOCK).

I'm certainly not the best person to make the final decision, but i 
would like to help you if you need me (write doc, or change this patch).

Cheers.

Paul.
