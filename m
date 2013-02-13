Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3BMEnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 23:43:00 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:47306 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3BMEm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 23:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <53da10fbf2904c6597568abdf10fe8f0@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359940959-32168-3-git-send-email-kys@microsoft.com>
	<tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
	<CAE9FiQXZRj84-fBwV4Hb0NQxcMxD1JTdsFXfyHMzaK-59TXjAg@mail.gmail.com>
	<7d06776025df4b788474c9710ed692ca@SN2PR03MB061.namprd03.prod.outlook.com>
	<511B0C84.5040806@zytor.com>
	<f6d62df8f3cb4076a2d3fe8a4f054a99@SN2PR03MB061.namprd03.prod.outlook.com>
	<511B0E79.6030007@zytor.com>
	<53da10fbf2904c6597568abdf10fe8f0@SN2PR03MB061.namprd03.prod.outlook.com>
Date: Tue, 12 Feb 2013 20:42:58 -0800
X-Google-Sender-Auth: AQ1RzLeloYJApqz3NiX0cy4zChc
Message-ID: <CAE9FiQVBXyF2ry==pnS3N+FrUObGW1HO3fCnKW1BxE7JpmzGcA@mail.gmail.com>
Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
From: Yinghai Lu <yinghai@kernel.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 7:58 PM, KY Srinivasan <kys@microsoft.com> wrote:
>
>
>> -----Original Message-----
>> From: H. Peter Anvin [mailto:hpa@zytor.com]
>> Sent: Tuesday, February 12, 2013 10:55 PM
>> To: KY Srinivasan
>> Cc: Yinghai Lu; mingo@kernel.org; linux-kernel@vger.kernel.org;
>> tglx@linutronix.de; hpa@linux.intel.com; linux-tip-commits@vger.kernel.org
>> Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
>> hypervisor interrupts
>>
>> On 02/12/2013 07:49 PM, KY Srinivasan wrote:
>> >>>
>> >>> The issue was that you could turn on CONFIG_HYPERV without enabling
>> >>> CONFIG_X86_LOCAL_APIC. Peter fixed it.
>> >>>
>> >>
>> >> He is asking why you are using IS_ENABLED() instead of #ifdef.  The
>> >> difference is that IS_ENABLED() works even for modules.
>> >
>> > My mistake!
>> >
>>
>> Well, which one do you need?
>
> I chose the IS_ENABLED() because I wanted to cover the case where HYPERV is configured as a module as well.
>

ok, so when HYPERV is built as module, actually it is partially module
as it put some code built-in already?
if user never load hyperv, those code will never not be used.

Can those code not be put in module _init function?

Thanks

Yinghai
