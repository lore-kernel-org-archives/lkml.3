Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3LDVNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:13:01 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:43564 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3LDVM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:12:57 -0500
MIME-Version: 1.0
In-Reply-To: <20131204170703.GA14859@kroah.com>
References: <CANsc=4VRLWhaVA15HrBEeM+FJC0tS+b5KKopDb7bP8nxzR8=zA@mail.gmail.com>
	<20131204070442.GA31665@kroah.com>
	<CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
	<20131204170703.GA14859@kroah.com>
Date: Wed, 4 Dec 2013 16:12:56 -0500
Message-ID: <CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com>
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
> Your pid implementation is broken, see my other email about that :(

Thank you for your remarks on pid. I'll try to correct that.

> And again, what's wrong with the existing tracing functionalty that is
> processor agnostic?  Why can't we just delete this driver today and use
> the existing trace code?

As far as I know, the tracing functionality in
/sys/kernel/debug/tracing does not take advantage of ETM. ETM is a
dedicated hardware that greatly reduces tracing overhead. It only
exists on ARM platforms.

I understand using sysfs here is not the cleanest way. I patched my
kernel to meet my needs (trace a specific process or address range),
and I thought these small modifications could be useful -- until
bigger work is done to remove ETM control from sysfs.

Do you think it's worth correcting my patch (for pid namespaces) and
re-submitting it? Or should we wait for someone to port ETM tracing to
debugfs?

Thanks,

Adrien
