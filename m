Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441Ab3LIKV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:21:26 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51269 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3LIKVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:21:23 -0500
Message-ID: <52A59991.1060305@gmail.com>
Date: Mon, 09 Dec 2013 11:21:05 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sergei Ianovich <ynvich@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>	 <1386543229-1542-1-git-send-email-ynvich@gmail.com>	 <1386543229-1542-6-git-send-email-ynvich@gmail.com>	 <201312090233.58592.arnd@arndb.de> <52A587A0.1050503@gmail.com> <1386581672.7152.108.camel@host5.omatika.ru>
In-Reply-To: <1386581672.7152.108.camel@host5.omatika.ru>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 10:34 AM, Sergei Ianovich wrote:
> On Mon, 2013-12-09 at 10:04 +0100, Daniel Mack wrote:
>> On 12/09/2013 02:33 AM, Arnd Bergmann wrote:
>>> On Sunday 08 December 2013, Sergei Ianovich wrote:
>>>> Non-dts implementation supply required DMA channel numbers as
>>>> IORESOURCE_DMA. However, there is was no way to get them from
>>>> device tree.
>>>
>>> I just wrote a lengthy reply to this email to explain in what ways
>>> you got it wrong, but then I saw that Daniel has already done all
>>> the work in the right way in August, so nevermind that.
>>>
>>> It hasn't made it upstream yet, but see http://list-archives.org/2013/08/07/linux-mtd-lists-infradead-org/patch-00-20-arm-pxa-move-core-and-drivers-to-dmaengine/f/3444199144
>>> for how it's done. Maybe Daniel can comment on the status of his
>>> patches.
>>
>> I recently rebased all my patches on top of 3.13-rc3, and will resend in
>> couple of days.
>>
>> The real problem here is that by reworking the DMA related PXA bits, all
>> drivers have to be changed at once, and a gradual transition seems
>> impossible. For that, I was asking for help in areas where I don't have
>> any hardware to test my patches on, but unfortunately, nobody got back
>> to me yet.
> 
> Nice to have Daniel in this conversation. Your patch series is a big and
> important work. However, I am not sure I will ever land as is exactly
> for this reason.

Well, I wouldn't be so certain about that statement. As I wrote in the
cover letter, most of the work is actually done, and I successfully
tested the new DMA support with a some of the drivers I ported. Others
were ported blindly, and in case of no reaction, I'd dare to merge them
and wait for people to report back in case of trouble.

The only real problem is the PXA camera driver, which does tricky things
like hot re-queuing of DMA descriptors. That one needs fixing before the
series can land.

> My proposal in to actually add new drivers for each platform device with
> DMA and mark new ones EXPERIMENTAL.

That would cause tree-wide cross-dependencies between drivers, because
the two DMA controllers can't be used at the same time, and the PXA
specific API will be unavailable when the mmp-dma driver is selected. My
patch series (and the DMA controller framework for that matter) aims for
the opposite - the unification of APIs and drivers.

> When they receive adequate testing
> we remove the tag and mark the old one OBSOLETE. When we have a new
> driver for every device presently supported, we will drop the whole old
> series.

Well, given the feedback I got for the series so far, I fear we'll be
off to maintain two drivers for each peripheral for a very long time.

I'd rather propose cracking the last nut that's left, and then get the
thing merged.

Arnd, Haojian? Any opinion here?



Daniel
