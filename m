Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaISABX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:01:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaISABV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:01:21 -0400
Message-ID: <541B71F9.70008@redhat.com>
Date: Thu, 18 Sep 2014 19:59:53 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Graeme Gregory <gg@slimlogic.co.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Graeme Gregory <graeme.gregory@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <201409180122.10631.arnd@arndb.de> <20140917234036.GC2464@xora-yoga-13> <6318202.hl003vettj@vostro.rjw.lan>
In-Reply-To: <6318202.hl003vettj@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 07:20 PM, Rafael J. Wysocki wrote:
> On Wednesday, September 17, 2014 04:40:36 PM Graeme Gregory wrote:
>> On Thu, Sep 18, 2014 at 01:22:10AM +0200, Arnd Bergmann wrote:
>>> On Wednesday 17 September 2014, Graeme Gregory wrote:
>>>> It sounds like from the discussions in other threads that ARM64 should
>>>> be following x86 and re-using DT bindings here. In which case there is
>>>> not need to submit things to UEFI organisation.
>>>>
>>>> What I got a little lost in has there been a formal decision about DT
>>>> bindings in _DSD?
>>>
>>> I think this is a discussion that still needs to happen: either we should
>>> recommend everyone to use _DSD in favor of the alternatives, or we
>>> should prohibit the use of _DSD. I have heard arguments both ways, but
>>> hopefully we can find an easy answer.
>>>
>>
>> This discussion is just not going to happen until people at @redhat.com
>> and people who have currently announced/released hardware are actually
>> willing to start talking about it.
>>
>> Id love to be able to put my foot down and ban the use of _DSD for
>> servers but I suspect that will not happen.
> 
> I'll probably should stay away from this discussion, but I can't resist. :-)
> 
> Please imagine the situation in which the same IP block is included in an ARM64
> SoC and in an x86 SoC that ships with ACPI tables and a _DSD for that device in
> them.  What benefit would be there from disallowing systems based on the ARM64
> SoC in question to ship the same _DSD in their ACPI tables?

"Disallowing" is a strong word in any case, because vendors own the
platform and will ship _DSD properties to describe those devices. So the
only "disallowing" Linux can do is to ignore entities present in ACPI
tables that have already been shipped by vendors.

Anyway. I think we all don't want a runaway frenzy with _DSD key/values
(generally there ought to be as few as possible, and additions should
only happen carefully). Broadly, there are three levels I see here:

0). Devices that are part of the core ACPI specification. None today
need key/value pairs, and I want to avoid this from growing.
1). Devices containing _DSD key/value pairs for a specific device but of
a common industry type, such as a network device. In this case, the 4-6
properties that might need to be specified (MAC address, PHY address,
PHY type, etc.) should be as minimal as possible and then standardized
into a common binding that vendors agree to support, and which is owned
and controlled by a neutral group such as ASWG.
2). Devices containining a specific ACPI ID that is unique to a given
vendor where that device implements value-add/offload/something non core
that can be owned entirely within a driver for one device. In that case,
maybe a vendor would define a minimal set of _DSD key/values and be on
the hook to maintain compatibility themselves.

I've chatted with a few people, and there will be a nice proposal
presented to ASWG/UEFI on how to provide an official process for
defining key/value pairs that are shared between common device types and
managed by such a forum, as in the cases 0 and 1 above. In the
meanwhile, there is only one _DSD use case in the early ACPI patches for
ARM servers (in the network MAC, to pass in the mac address and a couple
of PHY address/ID bits) and I've connected the vendors together asking
them to come up with the initial first example covering that.

None of this is core to ACPI enablement. It's specific to a few drivers
where also on x86 there will be _DSD properties.

Jon.

