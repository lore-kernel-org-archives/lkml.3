Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688Ab3BNPXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:23:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57925 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760489Ab3BNPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:23:48 -0500
Message-ID: <511D0180.2080809@gmail.com>
Date: Thu, 14 Feb 2013 07:23:44 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Add P state driver for Intel Core Processors
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com> <511BC16C.7040807@gmail.com> <CAOh2x=nwHbbngQm1PE7SfOLbHs3oMMb74zHXD9721OJzWo1+Tg@mail.gmail.com> <1540905.Sh9giL2bZe@vostro.rjw.lan>
In-Reply-To: <1540905.Sh9giL2bZe@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 04:21 AM, Rafael J. Wysocki wrote:
> On Thursday, February 14, 2013 09:38:21 AM Viresh Kumar wrote:
>> On Wed, Feb 13, 2013 at 10:08 PM, Dirk Brandewie
>> <dirk.brandewie@gmail.com> wrote:
>>> For the case where both are built-in the load order works my driver uses
>>> device_initcall() and acpi_cpufreq uses late_initcall().
>>>
>>> For the case where both are a module (which I was sure I tested) you are
>>> right
>>> I will have to do something.
>>>
>>> For now I propose to make my driver built-in only while I sort out the right
>>> solution for the module build.  Does this seem reasonable to everyone?
>>
>> Of-course i am missing something here. Why would anybody want to insert
>> acpi-cpufreq module when the system supports the pstate driver.
>>
>> In case they are mutually exclusive, then we can have something like
>> depends on !ACPI-DRIVER in the kconfig option of pstate driver.
>
> Yes.  Or the other way around (i.e. make acpi_cpufreq depend on
> !X86_INTEL_PSTATE).
>

The issue is that acpi-cpufreq still needs to be available for Intel processors 
before SandyBridge and for other x86 compatible processors we can't make
intel_pstate and acpi-cpufreq mutually exclusive.

Having intel_pstate built-in solves the issue without the need to patch
acpi-cpufreq.  I believe that most distros build the scaling drivers in
so the distro/user will make the explicit decision to use intel_pstate.


> Thanks,
> Rafael
>
>

