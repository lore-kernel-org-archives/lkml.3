Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3F0OP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:15:56 -0400
Received: from 1.mo1.mail-out.ovh.net ([178.32.127.22]:59564 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752622Ab3F0OPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:15:52 -0400
Message-ID: <51CC40B4.5070407@overkiz.com>
Date: Thu, 27 Jun 2013 15:40:04 +0200
From: =?ISO-8859-1?Q?Ga=EBl_PORTAY?= <g.portay@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        b.brezillon@overkiz.com
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com> <20130622112619.GA8075@amd.pavel.ucw.cz> <20130622164300.GB19420@earth.universe> <20130622194526.GA18809@amd.pavel.ucw.cz>
In-Reply-To: <20130622194526.GA18809@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4689373113452850003
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/2013 21:45, Pavel Machek wrote:
> On Sat 2013-06-22 18:43:01, Sebastian Reichel wrote:
>> On Sat, Jun 22, 2013 at 01:26:20PM +0200, Pavel Machek wrote:
>>> On Tue 2013-06-18 18:24:23, Gaël PORTAY wrote:
>>>> Currently, none of available triggers supports playing with the LED brightness
>>>> level.  The cycle trigger provides a way to define custom brightness cycle.
>>>> For example, it is easy to customize the cycle to mock up the rhythm of human
>>>> breathing which is a nice cycle to tell the user the system is doing something.
>>>>
>>>> This trigger is meant to be usable for waiting an event to happen, for example
>>>> when the system gets ready.  Those cycles may be used to reflect well known
>>>> system status (e.g. idle mode, startup...).
>>>>
>>>> This implementation provides several interfaces:
>>>>   - to define the cycle itself:
>>>>     * plot: definition of plot points using plot or rawplot files,
>>>>             each points defines the brightness level
>>>>     * interval: constant time interval between each plot point
>>>>   - to control the cycle:
>>>>     * repeat: the number of repetition of the whole plot cycle
>>>>               0 for an infinite loop
>>>>     * control: used to control the cycle trigger
>>>>       + "start"/"stop": to start/stop the cycle
>>>>       + "reset" to clear the cycle counter and the internal plot point index
>>>>       + "pause"/"resume" to pause/resume the cycle
>>>>
>>>> Signed-off-by: Gaël PORTAY <g.portay@overkiz.com>
>>> I'd say this should go to userspace.... and maybe should handle RGB
>>> leds. ... like the one on n900/HTC dream/....
>>>
>>> Actually, there's probably some daemon in maemo that already does
>>> this.
>> Actually the n900 has hardware support for this. There's a
>> programmable LED driver on the board, which is called LP5523.
>>
>> So... I don't think there's a daemon in maemo ;)
> You are right. LP5523 seems to do such effects on its own.
>
> But that means that there's good reason to include effects in the
> kernel, and that we should make sure same it has same interface as on
> n900.
>
> (Or invent suitable interface that can work on n900).
> 									Pavel
Hi Pavel,

I'm working on a new version that handle hardware support (like LP5523 
chip).

I will provide an implementation of the cycle trigger for LP5523 driver; 
but I will not be able to test it.

It will extend led class with new callbacks dedicated to cycle trigger.

Gaël
