Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaJQSiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:38:54 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53942 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaJQSix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:38:53 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <11223831.j9KAEfSQsY@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <11223831.j9KAEfSQsY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v5 00/12] Add ACPI _DSD and unified device properties support
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 17 Oct 2014 20:04:52 +0200
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Message-ID: <D04C5E60-527A-4CA9-954D-60A82AF0413A@arndb.de>
X-Provags-ID: V02:K0:nPItLCV6dVO9SElsrhUvO2w4WwrEIyzKQQN7++LOmUf
 xOxeKeuNWhyl63kfSRu5OGFF/y7F/zL0ZTuMa385gXdeYoSFbS
 9EKp6A6CS2gTGT1Go+9L6gs+3t01WTcB39uny7eG4C0hhF77/y
 ENceSS/YZtUrzuJYxQ45LMalS3EO5AZmwlm2TiF0xjwQebWL8t
 u8LhF30VNXg1DX0GGNvSRJ+p97JfDKsq2XHG3eYGl2344vgqKR
 Yy7WHDcQOf/2WZ21OQo3IZxNUbAKMpMjMfnkcW1yU8PeioCV1p
 5zSDp/pwOHj34Hzuz5l2ojdbFXNgD/YRaYZhFM3HwXbKL+Qel5
 PCwUF87873Bt8qoL7oNCDCcCzQiBpwGjtM6wzkqwszcwRSbRi0
 ts8YGyyEiTwzg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On October 17, 2014 2:01:33 PM CEST, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
>Hi Everyone,
>
>Hving had a couple of chats with Grant and Arnd during LinuxCon EU/LPC,
>we
>now have version 5 taking all feedback into account (hopefully).

Awesome, that was really fast. I'm currently on my way his me in the train, replying from my phone, but it looks good now. I'll have a more detailed look next week but I'm definitely happy to see this go in (to next and 3.19) now, any details we still find can be fixed on top.

> In
>short, if
>we are passed a struct fwnode_handle pointer, we can get from it to the
>appropriate device node pointer (either struct acpi_device or struct
>device_node)
>using container_of() after we've checked the type.  This is needed for
>the code
>that needs to access child nodes of a device in case when they don't
>have
>struct device representations (whatever the reason).  This has been
>suggested
>by Grant and pretty much everyone involved agrees that it's better that
>the
>alternatives presented so far.

Yes, it's nice enough that I now take back all the objections I had for the child accessory API.

        Arnd
