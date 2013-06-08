Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3FHNOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 09:14:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64797 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3FHNOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130606044129.GA1655@roeck-us.net>
References: <1370167987-14252-1-git-send-email-anish198519851985@gmail.com>
	<20130603152725.GA2644@roeck-us.net>
	<CAK7N6vrO4yFmEDotNnneG8EFgYOND9_iOXV5LnTPdCW0CMO10A@mail.gmail.com>
	<20130603222514.GA9082@roeck-us.net>
	<CAK7N6vpZB-bYohKFAjS55GVZO0MP8bHrLwBEja7EpqOXeqSW3g@mail.gmail.com>
	<CAK7N6vp4e6ZFyM3vwGmL3_GUYzzC-vapb4NCtgw9EsRtsRrGjQ@mail.gmail.com>
	<CAK7N6vp_ZDa4aB63-KbY3sUvhxUztt_cGM-0G+=ohkWN8cAAuA@mail.gmail.com>
	<20130606044129.GA1655@roeck-us.net>
Date: Sat, 8 Jun 2013 18:44:08 +0530
Message-ID: <CAK7N6vpkQoGWfgx5rUZqf4BtkiFyFgsnvb7RT_-abwM9xkbzFg@mail.gmail.com>
Subject: Re: [PATCH] [RFC]Watchdog:core: constant pinging until userspace
 timesout when delay very less
From: anish singh <anish198519851985@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: randy.dunlap@oracle.com,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 10:11 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, Jun 06, 2013 at 08:30:01AM +0530, anish singh wrote:
>> Hello Wim Van,
>> Can you look into below?
>>
> Please be patient. Wim tends to be busy.
Sorry, I will wait.
>
> Guenter
>
>> On Wed, Jun 5, 2013 at 8:39 AM, anish singh <anish198519851985@gmail.com> wrote:
>> > Hello Wim Van Sabroeck,
>> > Can I get your inputs on this?
>> >
>> > On Tue, Jun 4, 2013 at 8:39 AM, anish singh <anish198519851985@gmail.com> wrote:
>> >> On Tue, Jun 4, 2013 at 3:55 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> >>> On Mon, Jun 03, 2013 at 10:23:04PM +0530, anish singh wrote:
>> >>>> On Mon, Jun 3, 2013 at 8:57 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> >>>> > On Sun, Jun 02, 2013 at 03:43:07PM +0530, anish kumar wrote:
>> >>>> >> Certain watchdog drivers use a timer to keep kicking the watchdog at
>> >>>> >> a rate of 0.5s (HZ/2) untill userspace times out.They do this as
>> >>>> >> we can't guarantee that watchdog will be pinged fast enough
>> >>>> >> for all system loads, especially if timeout is configured for
>> >>>> >> less than or equal to 1 second(basically small values).
>> >>>> >>
>> >>>> >> As suggested by Wim Van Sebroeck & Guenter Roeck we should
>> >>>> >> add this functionality of individual watchdog drivers in the core
>> >>>> >> watchdog core.
>> >>>> >>
>> >>>> >> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>> >>>> >
>> >>>> > Not exactly what I had in mind. My idea was to enable the softdog only if
>> >>>> > the hardware watchdog's maximum timeout was low (say, less than a couple
>> >>>> > of minutes), and if a timeout larger than its maximum value was configured.
>> >>>>
>> >>>> watchdog_timeout_invalid wouldn't this check will fail if the user space tries
>> >>>> to set maximum timeout more that what driver can support?It would work
>> >>>> for pika_wdt.c as it is old watchdog driver and doesn't register with watchdog
>> >>>> framwork but new drivers has to pass this api.
>> >>>>
>> >>>> OR
>> >>>>
>> >>>> Do you want to remove this check and go as explained by you?I would
>> >>>> favour this approach though.
>> >>>>
>> >>> One would still have a check, but the enforced limits would no longer be
>> >>> the driver limits, but larger limits implemented in the watchdog core.
>> >> How much larger would be the big question here?Should it be configurable
>> >> property(sysfs?) or some hardcoding based on existing drivers?
>> >>
>> >> Before going for next patch, it would be better for me to wait for some
>> >> more comments.
>> >>>
>> >>>> > In that case, I would have set the hardware watchdog to its maximum value
>> >>>> > and use the softdog to ping it at a rate of, say, 50% of this maximum.
>> >>>> >
>> >>>> > If userspace would not ping the watchdog within its configured value,
>> >>>> > I would stop pinging the hardware watchdog and let it time out.
>> >>>>
>> >>>> One more question.Why is the return value of watchdog_ping int? Anyway
>> >>>> we discard it.
>> >>>
>> >>> I can not answer that question.
>> >>>
>> >>> Guenter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
