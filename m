Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaLETqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:46:19 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41297 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLETqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:46:17 -0500
MIME-Version: 1.0
In-Reply-To: <547C7420.4080801@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd> <547C539A.4010500@samsung.com> <20141201130437.GB24737@amd>
 <547C7420.4080801@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 5 Dec 2014 11:45:57 -0800
Message-ID: <CAK5ve-KMNszyz6br_Q_dOhvk=_8ev6Uz-ZhPnYBn-ZvuohQpVA@mail.gmail.com>
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 5:58 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> Hi Pavel,
>
> On 12/01/2014 02:04 PM, Pavel Machek wrote:
>>
>> Hi!
>>
>>>> How are faults cleared? Should it be list of strings, instead of
>>>> bitmask? We may want to add new fault modes in future...
>>>
>>>
>>> Faults are cleared by reading the attribute. I will add this note.
>>> There can be more than one fault at a time. I think that the bitmask
>>> is a flexible solution. I don't see any troubles related to adding
>>> new fault modes in the future, do you?
>>
>>
>> I do not think that "read attribute to clear" is good idea. Normally,
>> you'd want the error attribute world-readable, but you don't want
>> non-root users to clear the errors.
>
>
> This is also V4L2_CID_FLASH_FAULT control semantics.
> Moreover many devices clear the errors upon reading register.
> I don't see anything wrong in the fact that an user can clear
> an error. If the user has a permission to use a device then
> it also should be allowed to clear the errors.
>
>> I am not sure if bitmask is good solution. I'd return space-separated
>> strings like "overtemp". That way, there's good chance that other LED
>> drivers would be able to use similar interface...
>
>
> The format of a sysfs attribute should be concise.
> The error codes are generic and map directly to the V4L2 Flash
> error codes.
>

Actually I'd like to see those flash fault code defined in LED
subsystem. And V4L2 will just include LED flash header file to use it.
Because flash fault code is not for V4L2 specific but it's a feature
of LED flash devices.

For clearing error code of flash devices, I think it depends on the
hardware. If most of our LED flash is using reading to clear error
code, we probably can make it simple as this now. But what if some
other LED flash devices are using writing to clear error code? we
should provide a API to that?

-Bryan
