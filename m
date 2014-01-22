Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaAVRHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:07:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34655 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaAVRG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:06:57 -0500
Message-ID: <52DFFAA7.40008@infradead.org>
Date: Wed, 22 Jan 2014 09:06:47 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: randconfig build error with next-20140122, in arch/x86/kernel/devicetree.c
References: <CA+r1Zhjiw3Cv8AnsAhT==nkAYN2dxVXcWABpiVhtHXsW52YRkg@mail.gmail.com>
In-Reply-To: <CA+r1Zhjiw3Cv8AnsAhT==nkAYN2dxVXcWABpiVhtHXsW52YRkg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 08:34 AM, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> warning: (X86_INTEL_MID) selects INTEL_SCU_IPC which has unmet direct
> dependencies (X86 && X86_PLATFORM_DEVICES && X86_INTEL_MID)
> warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG
> which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME)
> warning: (X86_INTEL_MID) selects INTEL_SCU_IPC which has unmet direct
> dependencies (X86 && X86_PLATFORM_DEVICES && X86_INTEL_MID)
> warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG
> which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME)
> 
> arch/x86/kernel/devicetree.c:67:1: warning: data definition has no
> type or storage class [enabled by default]
>  module_init(add_bus_probe);
>  ^

For linux-next, devicetree.c needs to #include <linux/module.h>.
For mainline, it would have needed to #include <linux/init.h>.
However, it does neither of those.

See Documentation/SubmitChecklist #1:

1: If you use a facility then #include the file that defines/declares
   that facility.  Don't depend on other header files pulling in ones
   that you use.


> arch/x86/kernel/devicetree.c:67:1: error: type defaults to ‘int’ in
> declaration of ‘module_init’ [-Werror=implicit-int]
> arch/x86/kernel/devicetree.c:67:1: warning: parameter names (without
> types) in function declaration [enabled by default]
> arch/x86/kernel/devicetree.c:60:19: warning: ‘add_bus_probe’ defined
> but not used [-Wunused-function]
>  static int __init add_bus_probe(void)
>                    ^
> cc1: some warnings being treated as errors
> make[2]: *** [arch/x86/kernel/devicetree.o] Error 1
> 


-- 
~Randy
