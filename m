Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab3BMDre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:47:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60627 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab3BMDrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:47:33 -0500
Message-ID: <511B0C84.5040806@zytor.com>
Date: Tue, 12 Feb 2013 19:46:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Yinghai Lu <yinghai@kernel.org>, "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
References: <1359940959-32168-3-git-send-email-kys@microsoft.com> <tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org> <CAE9FiQXZRj84-fBwV4Hb0NQxcMxD1JTdsFXfyHMzaK-59TXjAg@mail.gmail.com> <7d06776025df4b788474c9710ed692ca@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <7d06776025df4b788474c9710ed692ca@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 07:32 PM, KY Srinivasan wrote:
>>>
>>> +#if IS_ENABLED(CONFIG_HYPERV)
>>> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
>>> +       hyperv_callback_vector hyperv_vector_handler
>>> +#endif /* CONFIG_HYPERV */
>>> +
>>
>> so #ifdef CONFIG_HYPERV does not work here?
>
> The issue was that you could turn on CONFIG_HYPERV without enabling
> CONFIG_X86_LOCAL_APIC. Peter fixed it.
>

He is asking why you are using IS_ENABLED() instead of #ifdef.  The 
difference is that IS_ENABLED() works even for modules.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

