Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934649Ab3E1Pwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:52:51 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47334 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934614Ab3E1Pwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:52:49 -0400
Message-ID: <51A4D2CE.90604@intel.com>
Date: Tue, 28 May 2013 08:52:46 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgT3R0ZQ==?= <jrg.otte@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rafael.j.wysocki@intel.com
Subject: Re: [v3.10-rc] intel_pstate question
References: <CADDKRnDH130wn8nVaT4xmCuEEcsGyBcjhj7pDjPMkeucUW+EWw@mail.gmail.com>
In-Reply-To: <CADDKRnDH130wn8nVaT4xmCuEEcsGyBcjhj7pDjPMkeucUW+EWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörg,

On 05/28/2013 08:02 AM, Jörg Otte wrote:
> Hi,
>
> the sysfs-interface of intel_pstate is different to that of the acpi driver:
> - intel_pstate shows current cpu-frequency in "cpuinfo_cur_freq" whereas
>    the acpi counterpart uses "scaling_cur_freq".
> - moreover cpuinfo_cur_freq is readable by root only, whereas
>    scaling_cur_freq is world readable.
>
>    A monitoring tool must take care of theese differences.
>    Is this intentional?
>

This is a side effect of the interface that intel_pstate presents to the cpufreq
core.

cpuinfo_cur_freq reports the value returned from the scaling driver.

scaling_cur_freq reports the current frequency in the governors policy structure.

intel_pstate has an internal governor so the core does not try to interpret
the policy structure.

I don't know why cpuinfo_cur_info is read-only root maybe Rafael knows the history.


> Thanks, Jörg
>
> Please CC me in answeres, I'm not subscribed.
>

