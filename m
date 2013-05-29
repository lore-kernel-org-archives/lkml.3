Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935287Ab3E2WOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:14:20 -0400
Received: from www.sr71.net ([198.145.64.142]:50562 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935228Ab3E2WOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:14:14 -0400
Message-ID: <51A67DB4.9090404@sr71.net>
Date: Wed, 29 May 2013 15:14:12 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: Toshi Kani <toshi.kani@hp.com>, Dave Hansen <dave.hansen@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: possible_cpus broken in linux-next
References: <51A6367E.1060400@intel.com>  <1369852557.16819.54.camel@misato.fc.hp.com> <1369853414.16819.56.camel@misato.fc.hp.com> <51A650BC.7030604@intel.com>
In-Reply-To: <51A650BC.7030604@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 12:02 PM, Rafael J. Wysocki wrote:
>>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>>> index 130ba0b..b9f0eec 100644
>>> --- a/drivers/base/cpu.c
>>> +++ b/drivers/base/cpu.c
>>> @@ -281,6 +281,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>>>       cpu->dev.bus = &cpu_subsys;
>>>       cpu->dev.release = cpu_device_release;
>>>       cpu->dev.offline_disabled = !cpu->hotpluggable;
>>> +    cpu->dev.offline = !cpu_online(num);
>>>   #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
>>>       cpu->dev.bus->uevent = arch_cpu_uevent;
>>>   #endif

This gets things working for me again.  Thanks for the quick response!

Tested-by: Dave Hansen <dave.hansen@intel.com>
