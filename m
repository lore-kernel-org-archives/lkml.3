Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbbAIIi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:38:56 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53729 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbbAIIiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:38:54 -0500
MIME-Version: 1.0
In-Reply-To: <19115179.EGFbFL174J@avalon>
References: <1413992061-28678-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <1645583.LAOF2HV7Iq@avalon> <CAL8zT=gUaBDiq=KC5YqCD5dqx2WO1PSXGckvchX_9XxDbJJEpw@mail.gmail.com>
 <19115179.EGFbFL174J@avalon>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Fri, 9 Jan 2015 09:38:38 +0100
X-Google-Sender-Auth: z08QLR5HjhP6MotuQtRq8Qyee3c
Message-ID: <CAL8zT=goqUXzK+HhxrJf=ZRTGgcT4agyR+QY9BYV3gtfWvZH4g@mail.gmail.com>
Subject: Re: [PATCH] adv7604: Add DT parsing support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        wsa@the-dreams.de, Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-10-27 0:30 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Jean-Michel,
>
> On Thursday 23 October 2014 07:51:50 Jean-Michel Hautbois wrote:
>> 2014-10-23 1:53 GMT+02:00 Laurent Pinchart:
>> > On Wednesday 22 October 2014 17:34:21 Jean-Michel Hautbois wrote:
>> >> This patch adds support for DT parsing of ADV7604 as well as ADV7611.
>> >> It needs to be improved in order to get ports parsing too.
>> >
>> > Let's improve it then :-) The DT bindings as proposed by this patch are
>> > incomplete, that's just asking for trouble.
>> >
>> > How would you model the adv7604 ports ?
>>
>> I am opened to suggestions :).
>> But it has to remain as simple as possible, ideally allowing for giving
>> names to the ports.
>> As done today, it works, ports are parsed but are all the same...
>
> The ADV7611 was easy, it had a single HDMI input only. The ADV7612 is easy as
> well as it just has two separate HDMI inputs.
>
> The ADV7604 is a more complex beast. The HDMI inputs shouldn't be much of an
> issue as they're independent and multiplexed internally. You can just create
> one pad per HDMI input.
>
> The analog inputs, however, can't be modeled as easily. A naive approach would
> be to create one pad for each of the 12 analog inputs, but the chip has three
> separate ADCs and can combine 3 inputs in a single digital video stream. I
> don't know how we should model support for that. Lars-Peter, Hans, would you
> have a revolutionary idea to same the world today ?

I get back to working on this specific part, but I don't know how
these analog inputs should be modeled.
On page 68 of ADV7604_HW_RevF there is Figure 11 showing typical
configurations using AIN_SEL[2:0].
I can see 4 inputs muxed : this would suggest to have 4 pads for analog inputs.
Not sure it makes sense though...

Thanks,
JM
