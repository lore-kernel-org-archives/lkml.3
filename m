Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbaDJMWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:22:19 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50273 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030419AbaDJMWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <CACna6ry+FOYykZpzycEjDA+ncGNLk6eXkwadXy548h9dgU1Bgw@mail.gmail.com>
References: <CA+5PVA5VBns=hkOSViucrpT340uG0=hgrWqf=LYHTBFAe74tBg@mail.gmail.com>
	<CACna6ry+FOYykZpzycEjDA+ncGNLk6eXkwadXy548h9dgU1Bgw@mail.gmail.com>
Date: Thu, 10 Apr 2014 08:22:12 -0400
X-Google-Sender-Auth: A7J584JPbUSK-qD-0kk931ITTZQ
Message-ID: <CA+5PVA4ijLmwRKHD4RYE6qSqkN7p8v1GB9w9GAGAJKG45bBTnw@mail.gmail.com>
Subject: Re: Oops in acpi_gpiochip_add on MacBookPro with Linux v3.14-12042-g69cd9eba3886
From: Josh Boyer <jwboyer@fedoraproject.org>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 2:50 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> 2014-04-09 23:09 GMT+02:00 Josh Boyer <jwboyer@fedoraproject.org>:
>> With Linux v3.14-12042-g69cd9eba3886 I get an oops from the bcma
>> module on the MacBookPro 10,2 I have here.  This works fine with Linux
>> v3.14-7333-g59ecc26004e7.  There have been no changes between those
>> two versions to bcma itself, but the GPIO merge did go in that window.
>>  I can attempt to do a bisect tomorrow, but looking over some of the
>> GPIO commits it seems pretty relevant to the ACPI GPIO changes.  I'm
>> hoping someone here has an idea on what the issue might be and has
>> some possible things for me to test for fixes.
>
> Bug report: https://lkml.org/lkml/2014/3/24/262
> Patch: https://lkml.org/lkml/2014/3/24/293
> Tested by Sabrina: https://lkml.org/lkml/2014/3/24/304
> (all links are for the same thread).
>
> Now you simply have to find above patch in some git tree :) Not sure
> if it's already in Linus's one.

Ah, wonderful.  I now wish I would have found those in my searching
before doing the bisect.  Oh well.  For what it's worth, my bisect
landed on the same commit.

The fix isn't in Linus' tree or linux-next.  I'm guessing Mika is
either still on vacation, or hasn't sent out the formal fix yet.

josh
