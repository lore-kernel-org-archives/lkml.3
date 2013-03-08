Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3CHHde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:33:34 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:36089 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3CHHdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:33:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAOS58YP4DrSXMPRCeNakac1hp5=1e3OkBCDF8u4vLwksj9+Kdw@mail.gmail.com>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-12-git-send-email-yinghai@kernel.org>
	<20130308064640.GL14556@mtj.dyndns.org>
	<CAE9FiQVO0aDrUKE_EV+A+aksqeukn6JMQqbfbKyw8JMV=DpaVw@mail.gmail.com>
	<CAOS58YP4DrSXMPRCeNakac1hp5=1e3OkBCDF8u4vLwksj9+Kdw@mail.gmail.com>
Date: Thu, 7 Mar 2013 23:33:32 -0800
X-Google-Sender-Auth: nkX01lJoo_Dyb_M3xHyU5OonMFo
Message-ID: <CAE9FiQXsNnvQ8CyrF65=bU_OYPkUCuULD0mJ3cKfnm2-0Lv4sA@mail.gmail.com>
Subject: Re: [PATCH 11/14] x86, acpi, numa: split SLIT handling out
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:19 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 7, 2013 at 11:18 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> ia64 like to call in this seqence
>> acpi_numa_init()
>> parse srat
>> parse slit
>> then
>> acpi_numa_arch_fixup()
>>
>> in this arch_fixup, it will try to fill dummy distance_matrix.
>>
>> so would to keep acpi_numa_init ...
>
> Can't it just call acpi_numa_init_srat() and then init_slit()?  What
> am I missing?

Yes, but need to break acpi_numa_init calling
in arch/ia64/kernel/setup.c

with
acpi_numa_init_srat()
acpi_numa_init_slit()
acpi_numa_arch_fixup()

current code is
acpi_numa_init calling arch_numa_arch_fixup()

Thanks

Yinghai
