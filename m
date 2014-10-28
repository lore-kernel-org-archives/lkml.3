Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaJ1JSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:18:55 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:59051 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaJ1JSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <4048602.9BsHAsA6cq@wuerfel>
References: <1414470034-16143-1-git-send-email-acourbot@nvidia.com> <4048602.9BsHAsA6cq@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 28 Oct 2014 18:18:32 +0900
Message-ID: <CAAVeFu+2OfRbU845uD29-oZww1Xu2VrGbx_m0J0SaoMr7Z8UQQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation: gpio: guidelines for bindings
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 6:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 28 October 2014 13:20:34 Alexandre Courbot wrote:
>> +GPIO properties should be named "[<name>-]gpios", with <name> being the con_id
>> +argument that is passed to gpiod_get(). While a NULL con_id is accepted by the
>> +GPIO API for compatibility reasons (resolving to the "gpios" property), it is
>> +not allowed for new bindings.
>> +
>> +GPIO properties can contain one or more GPIO phandles, but only in exceptional
>> +cases should they contain more than one. If your device uses several GPIOs with
>> +distinct functions, reference each of them under its own property, giving it a
>> +meaningful name. The only case where an array of GPIOs is accepted is when
>> +several GPIOs serve the same function (e.g. a parallel data line). In that case
>> +individual GPIOs can be retrieved using gpiod_get_index().
>> +
>> +The exact meaning of each gpios property must be documented in the device tree
>>  binding for each device.
>
> The binding should be written in an OS neutral way, so it would be better to avoid
> direct references to Linux APIs in the part that specifies the allowed properties.
>
> Could you reword this so the Linux interfaces are described in an "implementation
> notes" section that is separate from the main part?

You're right - will fix this and resubmit. Thanks!
