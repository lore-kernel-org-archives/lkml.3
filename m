Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3EXWMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:12:48 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62007 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab3EXWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <519EE672.9060508@samsung.com>
References: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
	<1369244832-23868-2-git-send-email-eu@felipetonello.com>
	<Pine.LNX.4.64.1305222230050.19558@axis700.grange>
	<2537252.KzShHU8h54@localhost.localdomain>
	<Pine.LNX.4.64.1305230920430.23354@axis700.grange>
	<519EE672.9060508@samsung.com>
Date: Fri, 24 May 2013 15:12:45 -0700
Message-ID: <CAGrhNMydmS3K9R=h+tgxUyYQcT_4yz8hmcDnZS2VHXhA3Nm2+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: sdhci: Added set_power sdhci_ops handler.
From: Felipe Tonello <eu@felipetonello.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-mmc@vger.kernel.org,
        ben-linux@fluff.org, cjb@laptop.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Thu, May 23, 2013 at 9:02 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> On 05/23/2013 04:25 PM, Guennadi Liakhovetski wrote:
>> On Wed, 22 May 2013, Felipe Ferreri Tonello wrote:
>>
>>> Hi Guennadi,
>>>
>>> On Wednesday, May 22, 2013 10:30:40 PM Guennadi Liakhovetski wrote:
>>>> On Wed, 22 May 2013, Felipe F. Tonello wrote:
>>>>> From: "Felipe F. Tonello" <eu@felipetonello.com>
>>>>>
>>>>> This is useful for power managment purposes if a sdhci child host wants to
>>>>> turn off some other peripheral also.
>>>>
>>>> Sorry, could you elaborate a bit? In what situations is it exactly useful?
>>>> And why cannot the regulator API be used there?
>>>
>>> Sorry about that.
>>>
>>> One example that I can think of is when you have a wifi module connected as a
>>> mmc card via sdio. So you can register a callback function in your machine
>>> source code to turn on/off the wifi module based on the mmc host power.
>>
>> Ok, understand. Your second patch in this series adds such a callback in
>> your SDHCI host driver and there it just calls a platform callback. I
>> don't think this is a good idea. First, we want to go away from platform
>> callbacks, because they are incompatible with DT. Second, because the
>> proper solution IMHO would be for your platform to export a regulator, and
>> the SDHCI core driver already includes regulator support.
> We can use the regulator framework.
> i think this callback function didn't need.
>

Ok, thanks for the feed back. Just to get things clear, is this
implementation using regulator framework already done?

BR,

Felipe

> Best Regards,
> Jaehoon Chung
>>
>>> I've seen this implementation in others mmc hosts, such as omap.
>>
>> Which, however, doesn't yet mean, it's a good idea :)
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
