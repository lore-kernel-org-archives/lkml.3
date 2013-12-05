Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3LEDtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:49:33 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:34962 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab3LEDt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:49:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131204230239.GB9205@kroah.com>
References: <CANsc=4VRLWhaVA15HrBEeM+FJC0tS+b5KKopDb7bP8nxzR8=zA@mail.gmail.com>
	<20131204070442.GA31665@kroah.com>
	<CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
	<20131204170703.GA14859@kroah.com>
	<CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com>
	<20131204230239.GB9205@kroah.com>
Date: Wed, 4 Dec 2013 22:49:25 -0500
Message-ID: <CANsc=4UGi5sMdUW5qQDzEJx4h8NDU+-b=xOLBAZtzbV5ugz3Fg@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/4 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> How much overhead does the existing tracing code have on ARM?  Is ETM
> still even needed?  Why not just use ETM for the core tracing code
> instead?

Coresight ETM is not just faster than /sys/kernel/debug/tracing, it
provides more detailed and customisable info. For instance, you can
trace every load, store, instruction fetch, along with the number of
cycles taken, with almost zero-overhead.

> What's wrong with the in-kernel tracing logic that you can't use that
> instead of the ETM stuff?

ETM has a different purpose. Integrating it in
/sys/kernel/debug/tracing would not take advantage of all its
features.
