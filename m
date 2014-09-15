Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaIOSBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:01:42 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:46624 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaIOSBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:01:41 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd1f:75a4:ff7c:16b1:aa54]
In-Reply-To: <20140915175250.8177DC40A42@trevor.secretlab.ca>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
	<1410530416-30200-11-git-send-email-hanjun.guo@linaro.org>
	<20140915064010.GD26649@localhost>
	<20140915175250.8177DC40A42@trevor.secretlab.ca>
Date: Mon, 15 Sep 2014 11:01:40 -0700
Message-ID: <CAOesGMjcXYjmUzZqGncnkN-uhnLC1ey2vqeqE4MQ5UDm8BaYTg@mail.gmail.com>
Subject: Re: [PATCH v4 10/18] ACPI / table: Print GIC information when MADT is parsed
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 10:52 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Sun, 14 Sep 2014 23:40:10 -0700, Olof Johansson <olof@lixom.net> wrote:
>> On Fri, Sep 12, 2014 at 10:00:08PM +0800, Hanjun Guo wrote:
>> > When MADT is parsed, print GIC information to make the boot
>> > log look pretty.
>>
>> If you do this for prettiness, having an example output in the commit
>> message would be a nice touch.
>
> Agreed.
>
>> The question is why it's needed though? Do we really need all this verbose
>> information in dmesg when it could be found out in other ways instead?
>>
>> x86 is notoriously verbose in some of these aspects, I'm not sure it's
>> something we need to mimic here?
>
> For consistency, it does make sense to have the common x86 and ARM64
> code outputing information in the same way, so I think the patch still
> makes sense. All of them could be moved to KERN_DEBUG as a separate
> patch if we want to cull early boot output. I would split that off and
> discuss it separately.

Yeah, pr_debug() makes sense here -- in particular if you're going to
have a potentially slow serial console to print all this to at info
level.

I disagree on order though, there's no reason to hold off fixing this
and doing it as a separate patch.


-Olof
