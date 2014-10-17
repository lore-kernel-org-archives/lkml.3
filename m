Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaJQAqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 20:46:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:52877 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaJQAq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 20:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,735,1406617200"; 
   d="scan'208";a="606754635"
Message-ID: <544065E3.4060909@linux.intel.com>
Date: Thu, 16 Oct 2014 17:42:11 -0700
From: sathyanarayanan kuppuswamy 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Reply-To: sathyanarayanan.kuppuswamy@linux.intel.com
Organization: Intel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v1 02/10] x86, intel-mid: Remove "weak" from function
 declarations
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com> <20141015170554.4063.62975.stgit@bhelgaas-glaptop2.roam.corp.google.com> <CAErSpo4sUi=75tM58_EFSFSWAHQUuAK3Yfaz4vTjCxdGWGhdug@mail.gmail.com>
In-Reply-To: <CAErSpo4sUi=75tM58_EFSFSWAHQUuAK3Yfaz4vTjCxdGWGhdug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 10/15/2014 04:26 PM, Bjorn Helgaas wrote:
> [+cc David, Kuppuswamy, x86; sorry, I botched my "stg mail" so you
> weren't included the first time]
>
> On Wed, Oct 15, 2014 at 11:05 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> For the following interfaces:
>>
>>    get_penwell_ops()
>>    get_cloverview_ops()
>>    get_tangier_ops()
>>
>> there is only one implementation, so they do not need to be marked "weak".
>>
>> Remove the "weak" attribute from their declarations.
>>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> CC: David Cohen <david.a.cohen@linux.intel.com>
>> CC: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
>> CC: x86@kernel.org
>> ---
>>   arch/x86/platform/intel-mid/intel_mid_weak_decls.h |    7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
>> index 46aa25c8ce06..3c1c3866d82b 100644
>> --- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
Please remove this file and move the contents to asm/intel-mid.h.
>> +++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
>> @@ -10,10 +10,9 @@
>>    */
>>
>>
>> -/* __attribute__((weak)) makes these declarations overridable */
>>   /* For every CPU addition a new get_<cpuname>_ops interface needs
>>    * to be added.
>>    */
>> -extern void *get_penwell_ops(void) __attribute__((weak));
>> -extern void *get_cloverview_ops(void) __attribute__((weak));
>> -extern void *get_tangier_ops(void) __attribute__((weak));
>> +extern void *get_penwell_ops(void);
>> +extern void *get_cloverview_ops(void);
>> +extern void *get_tangier_ops(void);
>>

-- 
Sathyanarayanan Kuppuswamy
Android kernel developer

