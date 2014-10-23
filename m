Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaJWFKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:10:43 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:40244 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaJWFKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAE1zot+FL54r3a6-qJwDti3D2dGCSwN=a0g0ki28cy1ToXgSfg@mail.gmail.com>
References: <1413384491-23703-1-git-send-email-octavian.purdila@intel.com>
 <1413384491-23703-4-git-send-email-octavian.purdila@intel.com>
 <CAAVeFuJ4B37YgvTBctXqmtWJtg3b19PDt1EEZF5Rc6KVXZzUtw@mail.gmail.com> <CAE1zot+FL54r3a6-qJwDti3D2dGCSwN=a0g0ki28cy1ToXgSfg@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 23 Oct 2014 14:10:19 +0900
Message-ID: <CAAVeFuKcteLaNp6C3EuSmGxpb_8aGYXw4FYjFqXXH2St5mbZDA@mail.gmail.com>
Subject: Re: [PATCH v8 3/4] gpiolib: add irq_not_threaded flag to gpio_chip
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 7:19 PM, Octavian Purdila
<octavian.purdila@intel.com> wrote:
> On Mon, Oct 20, 2014 at 8:08 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
>>
>> On Wed, Oct 15, 2014 at 11:48 PM, Octavian Purdila
>> <octavian.purdila@intel.com> wrote:
>> > Some GPIO chips (e.g. the DLN2 USB adapter) have blocking get/set
>> > operation but do not need a threaded irq handler.
>>
>> Sorry if you already explained this (I have been a little bit late
>> with the GPIO reviews recently), but does this optimization bring a
>> significant benefit that justifies adding another field in struct
>> gpio_chip? If so it would be nice to have it in the commit message. If
>> not, do we need this at all?
>
> Hi Alexandre,
>
> In the case DLN2 USB GPIO adapter the GPIO interrupt is generated in
> the completion routine of a receive URB, which means that we are in
> interrupt context. If a threaded irq is used, we would have to
> schedule work instead of running to interrupt handler directly which
> is unnecessary and adds latency.
>
> BTW, AFAIC Linus W already merged this patch in his next tree, I am
> keeping it in this series because it was not pulled in the mfd-next
> tree.

You're right, it's all good then. Thanks for the explanation.
