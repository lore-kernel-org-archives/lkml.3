Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaDWOFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:05:08 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:63432 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbaDWOFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140422155602.GA19762@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397135274-10764-3-git-send-email-antoine.tenart@free-electrons.com>
	<5347AFF4.3050607@gmail.com>
	<20140411123737.GA5903@kwain>
	<5347EF8A.8040600@gmail.com>
	<CACRpkdb1eijF-4e=KyhS=9S868NALdyJJaNnzjUubXnapWEeMg@mail.gmail.com>
	<20140422155602.GA19762@kwain>
Date: Wed, 23 Apr 2014 16:05:03 +0200
Message-ID: <CACRpkdZ2U6vSShF8QmxZsPsKcwg4TH89xKwQMrbin4zN0xAAXA@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/5] pinctrl: berlin: add a pinctrl driver for
 Marvell Berlin SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zmxu@marvell.com, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 5:56 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:
> On Tue, Apr 22, 2014 at 02:52:10PM +0200, Linus Walleij wrote:
>> On Fri, Apr 11, 2014 at 3:35 PM, Sebastian Hesselbarth
>> <sebastian.hesselbarth@gmail.com> wrote:
>> > On 04/11/2014 02:37 PM, Antoine Ténart wrote:
>> >> On Fri, Apr 11, 2014 at 11:03:48AM +0200, Sebastian Hesselbarth wrote:
>> >>> On 04/10/2014 03:07 PM, Antoine Ténart wrote:
>>
>> >>> Having said that, the above assumes that each function is unique
>> >>> but IIRC the idea of the function table was to group pins/groups
>> >>> with the same function, e.g. function "gpio", groups 1,7,25,...
>> >>
>> >> Most of the functions you can use on the Berlin they will be unique and
>> >> would
>> >> only be used in one group, except for the 'gpio' one.
>> >
>> > Yeah, I had a similar discussion about it back then for mvebu. IIRC, the
>> > correct answer is: Have a list of functions with groups assigned to it
>> > no matter if there is only one group per function (or 40 per function as
>> > it will be for gpio).
>> >
>> > Maybe Linus can give an update on how to deal with it?
>>
>> Have you considered implementing pinmux_ops
>> .gpio_request_enable(), .gpio_set_direction() and
>> .gpio_disable_free() instead of defining groups for each
>> and every GPIO?
>
> The function 'gpio' can be found on different groups. But the Berlin pin muxing
> does not allow to configure a pin individually. It is then not possible to mux
> GPIO pins individually. For example the 'gpio' function of group 'GSM2' on the
> BG2Q will mux GPIOs 17 *and* 18.
>
> Groups does not have more than a single 'gpio' function.
>
> Since the gpio_request_enable() comment says 'Implement this only if you can mux
> every pin individually as GPIO', I did not considered implementing these
> functions.

OK makes perfect sense.

Then I guess the current implementation is the best alternative,
but I may need to look closer.

Yours,
Linus Walleij
