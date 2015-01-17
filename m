Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbbAQRyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 12:54:19 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:53929 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbAQRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 12:54:17 -0500
MIME-Version: 1.0
In-Reply-To: <1887263.kzglbjcc0t@wuerfel>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1809831.d9GPSfLUEN@wuerfel> <20150116154913.GW7091@arm.com> <1887263.kzglbjcc0t@wuerfel>
From: Rob Herring <robh@kernel.org>
Date: Sat, 17 Jan 2015 11:53:56 -0600
X-Google-Sender-Auth: UfqoOXC6KF21xOQ4W8-VDyGRKGY
Message-ID: <CAL_JsqJzx62Vt09PK=G0WZsr0hXPj5oB=fxtVtfQD2Ys6=n-iQ@mail.gmail.com>
Subject: Re: [Linaro-acpi] [PATCH v7 00/17] Introduce ACPI for ARM64 based on
 ACPI 5.1
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Yijing Wang <wangyijing@huawei.com>, Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 9:53 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 16 January 2015 15:49:13 Will Deacon wrote:
>>
>> The on-board ethernet on Seattle requires the driver to program its AXI
>> attributes, so configuring it to be a coherent master actually means
>> "program the same cacheable AXI settings as you have on the CPU". That
>> sounds like Linux should be doing it to me, but even if the firmware takes
>> a guess at "normal cacheable WBRWA", it's not clear to me whether that
>> register persists across things like adapter reset.
>>
>> Tom?
>>
>> There's also the situation where the firmware hasn't initialised the
>> register and Linux realises this during probe. What should it do then?
>
> In case of a 10gbit ethernet adapter, there really should be no question
> regarding whether to set it coherent or not. Can't Linux just always
> set this AXI attribute in the driver?

Coherency is easy to get wrong, so the path could be broken. In fact
on highbank, it is the non-coherent path that is broken. You could
find out pretty far down the road that you need to change
configuration. But yes, I agree with your point as you pretty much
have to run coherently for decent performance on high speed
peripherals.

If we are mucking with AXI specifics in the kernel on ACPI systems,
we've already failed to abstract the platform. AXI is not even part of
the architecture.

Rob
