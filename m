Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaLJMUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:20:25 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45926 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLJMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:20:22 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ef-54883a8415aa
Message-id: <54883A70.7070903@samsung.com>
Date: Wed, 10 Dec 2014 13:20:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com> <20141204161201.GB29080@amd>
In-reply-to: <20141204161201.GB29080@amd>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xa7otVh0hBsd+i1jcWneO1WLjjPWs
	Fkd3TmSyuP7lOavF/CNAsf43C1ktzr1ayWjRe/U5o8XZpjfsFve/HmW0uLxrDpvF1jfrGC16
	NmxltVh6/SKTxd1TR9ksJkxfy2LRuvcIu8XuXU9ZLc7sX8nmIOyxZt4aRo/Lfb1MHjtn3WX3
	WLn8C5vH4a8LWTw2repk87hzbQ+bx575P1g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6
	dglcGav/rGIqeCBYcWF9TgPjZL4uRk4OCQETiXu/ZzJC2GISF+6tZ+ti5OIQEljKKLF12SVm
	COcTo8S9a3+AMhwcvAJaEv8mq4M0sAioStx/PY0JxGYTMJToPdoHNkhUIELi5N097CA2r4Cg
	xI/J91hAbBEBH4mbX68wgsxkFnjILPHp8hywBmGBEImt+0+zQCz7zShxaedVdpBlnAKaEvee
	m4OYzAJ6EvcvaoGUMwvIS2xe85Z5AqPALCQrZiFUzUJStYCReRWjaGppckFxUnqukV5xYm5x
	aV66XnJ+7iZGSFR+3cG49JjVIUYBDkYlHt4dim0hQqyJZcWVuYcYJTiYlUR430h2hAjxpiRW
	VqUW5ccXleakFh9iZOLglGpgLLK+pxY9tWVRYUP3923LRHXWFN25Lr963Z5dd8oU7W7uZCwp
	WGmQV8vL9ZIrXcRK2as3Z0beYeHUSr63aw/1C05967Vg51EvgYP9PpLLvTZvv7amu33z3Vky
	sq58z6bUF2s3rZw6Py7t8knZiRsc5A/J3IvfYzfzMSPDVD/dLrdt1XZ6C253KrEUZyQaajEX
	FScCAMAMfyqoAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/12/14 17:12, Pavel Machek wrote:
>>>> +- maxim,boost-mode :
>>>> > >>+	In boost mode the device can produce up to 1.2A of total current
>>>> > >>+	on both outputs. The maximum current on each output is reduced
>>>> > >>+	to 625mA then. If there are two child led nodes defined then boost
>>>> > >>+	is enabled by default.
>>>> > >>+	Possible values:
>>>> > >>+		MAX77693_LED_BOOST_OFF - no boost,
>>>> > >>+		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
>>>> > >>+		MAX77693_LED_BOOST_FIXED - fixed mode.
>>>> > >>+- maxim,boost-vout : Output voltage of the boost module in millivolts.
>>>> > >>+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
>>>> > >>+	if chip estimates that system voltage could drop below this level due
>>>> > >>+	to flash power consumption.
>>>> > >>+
>>>> > >>+Required properties of the LED child node:
>>>> > >>+- label : see Documentation/devicetree/bindings/leds/common.txt
>>>> > >>+- maxim,fled_id : Identifier of the fled output the led is connected to;
>>> > >
>>> > >I'm pretty sure this will be needed for about every chip that can drive
>>> > >multiple LEDs. Shouldn't it be documented in the generic documentation?
>> > 
>> > OK.
>
> Well... "fled_id" is not exactly suitable name. On other busses, it
> would be "reg = <1>"?

I think we need to clarify what the LED device node subnodes really mean.
I thought initially they describe a physical current output of the LED
controller, but it turns out the subnode corresponds to a LED attached
to the LED controller.  Since a LED can be connected to multiple outputs
of the LED controller I think 'reg' property doesn't make sense here.

Then presumably we should use a property in each subnode, telling which
LED controller outputs a LED is connected to?

For instance, if we assign numbers 0, 1 to FLED1, FLED2 outputs of
MAX77693 and there is just one LED connected to those outputs we would
have something like:

max77693: led {
	compatible = "maxim,max77693-led";	
	...
	led1 {
		maxim,fled-sources = <0 1>;
		...
	};
};

Feel free to propose better name for the property, I guess we need to
avoid "maxim,current-sources" due to ambiguity of the word "current".

--
Regards,
Sylwester
