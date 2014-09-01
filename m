Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaIARcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:32:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58856 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaIARci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:32:38 -0400
Message-ID: <5404ADDE.1090205@arm.com>
Date: Mon, 01 Sep 2014 18:33:18 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>, Mark Brown <broonie@kernel.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support
 for probing from ACPI
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org> <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org> <2861461.8zNpLC3I2n@wuerfel> <20140901152854.GJ2953@xora-haswell.xora.org.uk> <20140901165333.GE608@arm.com> <20140901165853.GJ29327@sirena.org.uk> <5404A821.5020207@arm.com> <20140901171451.GH608@arm.com>
In-Reply-To: <20140901171451.GH608@arm.com>
X-OriginalArrivalTime: 01 Sep 2014 17:32:33.0315 (UTC) FILETIME=[B6A31F30:01CFC60A]
X-MC-Unique: 114090118323503501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/14 18:14, Catalin Marinas wrote:
> On Mon, Sep 01, 2014 at 06:08:49PM +0100, Sudeep Holla wrote:
>> On 01/09/14 17:58, Mark Brown wrote:
>>> On Mon, Sep 01, 2014 at 05:53:33PM +0100, Catalin Marinas wrote:
>>>
>>>> Confused. Then how come smsc911x_drv_probe() has this line:
>>>
>>>> 	acpi_handle *ahandle = ACPI_HANDLE(&pdev->dev);
>>>
>>>> without any #ifdef's.
>>>
>>> There's a stub smsc911x_probe_config_acpi() provided in the non-ACPI
>>> case, Arnd's suggestion is basically to remove the stub.
>>>
>>
>> I think Catalin is referring to ACPI_HANDLE used without any #ifdefs
>>
>> Catalin, few macros like ACPI_HANDLE and ACPI_PTR are defined in
>> include/linux/acpi.h even when CONFIG_ACPI is not set mainly to
>> avoid #ifdef's around simple assignments like the above one and one
>> in platform_driver.acpi_match_table
>
> My comment was to Graeme who said that #ifdef's were needed because
> acpi_handle (lowercase) was not defined in the !CONFIG_ACPI case.
> However, further down in the patch it was used without any #ifdef's.
>

Ah OK, I misunderstood. In that case Graeme statement is wrong.
IIRC acpi_handle is not structure, it's just a ptr used for object
references in ACPI namespace and is available even when !CONFIG_ACPI

Regards,
Sudeep

