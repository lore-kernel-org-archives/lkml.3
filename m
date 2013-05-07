Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab3EGSoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:44:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58652 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760082Ab3EGSoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:44:03 -0400
Message-ID: <51894B6F.9040108@zytor.com>
Date: Tue, 07 May 2013 11:43:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Lenovo Yoga 13 touchpad regression
References: <5188905A.4020703@zytor.com> <CAJiQ=7DDpCUTXasoo8qbrv-g87Ak7NFvKXSn6+cfhKai06yG_A@mail.gmail.com>
In-Reply-To: <CAJiQ=7DDpCUTXasoo8qbrv-g87Ak7NFvKXSn6+cfhKai06yG_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 11:05 PM, Kevin Cernekee wrote:
> On Mon, May 6, 2013 at 10:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Hello,
>>
>> The touchpad on Lenovo Yoga 13 seems to have broken some time between 3.4
>> and the current kernel.  The dmesg is full of spewage:
>>
>> [  256.246481] atkbd serio0: Use 'setkeycodes e03e <keycode>' to make it
>> known.
>> [  256.251473] atkbd serio0: Unknown key released (translated set 2, code
>> 0xbe on isa0060/serio0
>>
>> ... about once per second; I am wondering if the touchpad is spewing output
>> onto the keyboard channel or if there is something else wrong.
>
>  From googling around this looks like a Synaptics unit.
>
> Is it being detected by the ALPS driver?  If so, did it use the ALPS
> driver in 3.4?
>
> alps.c was changed to identify several new models, but PS/2 touchpad
> identification uses "magic knock sequences" which may be prone to
> false positives.  This is something we should watch for.
>

This is how it is detected:

[    1.843709] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, 
id: 0x1e2b1, caps: 0xd00223/0x840300/0x123c00, board id: 1800, fw id: 
1148377
[    1.902569] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio1/input/input3

I think this is the Synaptics driver as opposed to ALPS.

What is really bizarre is that some time today the touchpad 
spontaneously started to work.  However, after a reboot it no longer 
worked again.  This is on 3.8.11.  The keycode spewage continued, however.

	-hpa

