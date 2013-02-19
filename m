Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab3BSJQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:16:47 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:37353 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab3BSJQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:16:44 -0500
Message-ID: <512342F8.5060200@suse.cz>
Date: Tue, 19 Feb 2013 10:16:40 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5qYSBOw7x0emVs?= <Anja@nuetzel-hh.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Jeff Mahoney <jeffm@suse.com>,
        mmarek@suse.cz,
        =?UTF-8?B?RGlldGVyIE7DvHR6ZWw=?= <Dieter@nuetzel-hh.de>,
        stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression] openSUSE 12.2 stable kernel 3.7.8-1 big USB 2.0
 slowdown
References: <Pine.LNX.4.44L0.1302182155510.12532-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302182155510.12532-100000@netrider.rowland.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 AM, Alan Stern wrote:
> On Mon, 18 Feb 2013, Jiri Slaby wrote:
> 
>> On 02/18/2013 06:25 AM, Anja Nützel wrote:
>>> Maybe it startet with 3.7.7.
>>> I could copy several MB onto my USB 2.0 sticks with 3.7.6. (I think).
>>> Even with full speed.
>>>
>>> With openSUSE 12.2 DVD (kernel 3.4.x) it works OK, too.
>>>
>>> Now it degrates to 12 mbits (full-speed USB only).
>>
>> This is an upstream 3.7.7 stable regression, I think. Some of these
>> patches perhaps:
>> d7da098 USB: EHCI: fix for leaking isochronous data
>> caa891a USB: storage: optimize to match the Huawei USB storage devices
>> and support new switch command
>> 08b4bfd USB: storage: Define a new macro for USB storage match rules
>> 390077b usb: Using correct way to clear usb3.0 device's remote wakeup
>> feature.
>> 93dffb7 USB: EHCI: fix bug in scheduling periodic split transfers
>> bf79379 USB: EHCI: fix timer bug affecting port resume
>> d01875f USB: EHCI: unlink one async QH at a time
>> 269ef9f USB: EHCI: remove ASS/PSS polling timeout
>>
>> Alan, any ideas?
> 
> A lot of people have reported problems caused by the last one 
> (269ef9f).  I haven't had time to investigate yet (just got back from 
> vacation).

I reverted that one in:
http://labs.suse.cz/jslaby/bug-804367/

Anja, could you test that kernel?

-- 
js
suse labs
