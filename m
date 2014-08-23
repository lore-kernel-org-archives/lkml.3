Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaHWRL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:11:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaHWRL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:11:56 -0400
Message-ID: <53F8CB55.5030209@suse.de>
Date: Sat, 23 Aug 2014 19:11:49 +0200
From: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Heiko Stuebner <heiko@sntech.de>, linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Figa <t.figa@samsung.com>, Will Deacon <will.deacon@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-watchdog@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-pm@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v7 04/11] arm: Support restart through restart handler
 call chain
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net> <1408495538-27480-5-git-send-email-linux@roeck-us.net> <53F69DBA.4070806@suse.de> <20140822021947.GA17788@roeck-us.net>
In-Reply-To: <20140822021947.GA17788@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.08.2014 04:19, schrieb Guenter Roeck:
> On Fri, Aug 22, 2014 at 03:32:42AM +0200, Andreas Färber wrote:
>> Am 20.08.2014 02:45, schrieb Guenter Roeck:
>>> The kernel core now supports a restart handler call chain for system
>>> restart functions.
>>>
>>> With this change, the arm_pm_restart callback is now optional, so
>>> drop its initialization and check if it is set before calling it.
>>> Only call the kernel restart handler if arm_pm_restart is not set.
>> [...]
>>> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
>>> index 81ef686..ea279f7 100644
>>> --- a/arch/arm/kernel/process.c
>>> +++ b/arch/arm/kernel/process.c
>>> @@ -114,17 +114,13 @@ void soft_restart(unsigned long addr)
>>>  	BUG();
>>>  }
>>>  
>>> -static void null_restart(enum reboot_mode reboot_mode, const char *cmd)
>>> -{
>>> -}
>>> -
>>>  /*
>>>   * Function pointers to optional machine specific functions
>>>   */
>>>  void (*pm_power_off)(void);
>>>  EXPORT_SYMBOL(pm_power_off);
>>>  
>>> -void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
>>> +void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>>
>> Stupid newbie question maybe, but isn't this variable uninitialized now,
>> like any non-static variable in C99? Or does the kernel assure that all
>> such "fields" are zero-initialized?
>>
> It is initialized with NULL, like all other global and static variables in the
> kernel (and like pm_power_off a few lines above).

Thanks for the explanation. In that case FWIW

Reviewed-by: Andreas Färber <afaerber@suse.de>

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
