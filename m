Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab3ICRf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:35:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41637 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab3ICRfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:35:54 -0400
Message-ID: <52261DC8.4070307@zytor.com>
Date: Tue, 03 Sep 2013 10:35:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Li, Fei" <fei.li@intel.com>
CC: Ingo Molnar <mingo@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "holt@sgi.com" <holt@sgi.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <20130821072940.GB27495@gmail.com> <69b80c44-3245-4393-b6e9-4d8a7f3d3c66@email.android.com> <BEC9F67575FA1E429CA7CF5AE9BE3634012ED68C@SHSMSX104.ccr.corp.intel.com> <7233d29e-ea01-4eb6-8018-b9c8e3730a30@email.android.com> <BEC9F67575FA1E429CA7CF5AE9BE3634012EDD40@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <BEC9F67575FA1E429CA7CF5AE9BE3634012EDD40@SHSMSX104.ccr.corp.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 08:32 PM, Li, Fei wrote:
> 
> In fact, ACPI method also implements reset by writing RESET_VALUE into RESET_REG
> port. In our platform, it also uses port 0xCF9. The difference between cold and wart reset
> is whether power cycle is involved or not. After all, this is another topic.
> 
> From the source code, CF9 boot method are still used by some apple MAC and dell
> platforms if I understand correctly.
> 
> Back to our patch, if you really concern the effect of cold reboot 0x0E to current existed
> platforms, we can set the default value of reboot_mode as REBOOT_WARM.
> 
> Does it make sense?
> 

Sort-of-kind-of.

The problem here is that "cold" versus "warm" reboot seems to have
slightly different meanings for BIOS (bypass POST) and the CF9 register
(where I presume it is a "deeper" platform reset of some kind ... is it
even well-defined what the semantics are?)

I could be wrong and the cold/warm reset values in CF9 end up having
exactly the same function as the magic BIOS signature does; if so, then
I would like to be told so explicitly, ideally with an explanation about
how it works on the hw level (or a pointer to relevant documentation,
Intel internal docs are fine.)

Finally, again, does this solve a real problem?

	-hpa


