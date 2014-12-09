Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbaLINOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:14:20 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8857 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbaLINOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:14:12 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-00-5486f5a1094c
Message-id: <5486F5A0.9060700@samsung.com>
Date: Tue, 09 Dec 2014 14:14:08 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH/RFC v9 02/19] Documentation: leds: Add description of LED
 Flash class extension
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-3-git-send-email-j.anaszewski@samsung.com>
 <20141203170818.GN14746@valkosipuli.retiisi.org.uk>
 <54802C9F.8030101@samsung.com>
 <20141209123819.GJ15559@valkosipuli.retiisi.org.uk>
In-reply-to: <20141209123819.GJ15559@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xa7oLv7aFGGw+qmSxccZ6VoujOycy
	WfS/Wchqce7VSkaLs01v2C0u75rDZrH1zTpGi54NW1ktll6/yGRx99RRNosJ09eyWLTuPcJu
	sXvXU1aLw2/aWS3O7F/J5sDvsWbeGkaPy329TB47Z91l91i5/Aubx+GvC1k8Nq3qZPPYM/8H
	q0ffllWMHitWf2f3+LxJLoArissmJTUnsyy1SN8ugStj83qRgkvsFQ9mvGFqYOxn62Lk5JAQ
	MJFoaFvBAmGLSVy4tx4ozsUhJLCUUWLp+25mCOcjo8TlU/PZuxg5OHgFtCQ+TzAGaWARUJWY
	29PFDGKzCRhK/HzxmgnEFhWIkPhzeh8riM0rICjxY/I9sAUiAmoSTzc9ZAGZySxwjUliw/qT
	YA3CAqkSRzffg1o2hUni3O1jYOdxCjhIbHu5gx3EZhawllg5aRsjhC0vsXnNW+YJjAKzkCyZ
	haRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCIu3LDsbFx6wOMQpwMCrx8Jor
	toYIsSaWFVfmHmKU4GBWEuGdcrQtRIg3JbGyKrUoP76oNCe1+BAjEwenVANj8UujwJrKlS+S
	ziiHz1qd47BtenjnjRmOIRciLCObZee+1PjqZ/9x2j/BuUsXalzk4ntuwl7ieM7t+5LZMtIT
	vY+ynGfe1jF5xl+PMFX3o/k/Hmjd85nqd7Ys8Xs+05f6tf2abjN3l04SmFnnvf14TmDR7Ry+
	7tMiFdVr1pr18vAI84W5yZ9VYinOSDTUYi4qTgQATckGr5ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 12/09/2014 01:38 PM, Sakari Ailus wrote:

[...]

>>> How does the user btw. figure out which flash LEDs may be strobed
>>> synchronously using the LED flash interface?
>>
>> The flash_sync_strobe argument is absent if synchronized strobe
>> is not available for a LED. The driver defines this by setting
>> newly added LED_DEV_CAP_COMPOUND flag.
>
> I meant that how does the user figure out which LEDs may be strobed
> synchronously, together. Say, if you have two of these chips and four LEDs,
> then how does it work? :-)
>

User can figure it out by checking the existence of the
flash_sync_strobe attribute. Sub-leds can by synchronized only
when are driven by common chip. It is assumed that sub-leds of
one chip will have common segment in their name, defined in
DT 'label' property. Maybe we should enforce it by adding another
property to the leds/common.txt DT binding, e.g. 'device-prefix'?

Best Regards,
Jacek Anaszewski

