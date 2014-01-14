Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaANX33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:29:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34317 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaANX30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:29:26 -0500
Message-ID: <52D5C83B.4000507@ti.com>
Date: Tue, 14 Jan 2014 18:28:59 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2] ARM: OMAP4460: cpuidle: Extend PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD
 on cpuidle
References: <1382467484-16957-1-git-send-email-grygorii.strashko@ti.com> <5266CCE3.1090801@ti.com> <20131114183535.GL10317@atomide.com> <20131115153608.GX10317@atomide.com> <52864585.6030206@linaro.org> <20131115161137.GY10317@atomide.com> <5286480B.3060801@ti.com> <CAGa+x863_MQ22h+U=KtK++3aG2F_X4x57Xtfe16GYXKNiaWX4A@mail.gmail.com>
In-Reply-To: <CAGa+x863_MQ22h+U=KtK++3aG2F_X4x57Xtfe16GYXKNiaWX4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 January 2014 04:26 PM, Kevin Hilman wrote:
> On Fri, Nov 15, 2013 at 8:12 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> On Friday 15 November 2013 11:11 AM, Tony Lindgren wrote:
>>> * Taras Kondratiuk <taras.kondratiuk@linaro.org> [131115 08:03]:
>>>> On 11/15/2013 05:36 PM, Tony Lindgren wrote:
>>>>> * Tony Lindgren <tony@atomide.com> [131114 10:36]:
>>>>>> * Grygorii Strashko <grygorii.strashko@ti.com> [131022 12:09]:
>>>>>>> The same workaround as ff999b8a0983ee15668394ed49e38d3568fc6859
>>>>>>> "ARM: OMAP4460: Workaround for ROM bug because of CA9 r2pX GIC ..."
>>>>>>> need to be applied not only when system is booting, but when MPUSS hits
>>>>>>> OSWR state through CPUIdle too. Without this WA the same issue is
>>>>>>> reproduced now on boards PandaES and Tablet/Blaze with SOM OMAP4460
>>>>>>> when CONFIG_CPU_IDLE is enabled.
>>>>>>> After MPUSS has enterred OSWR and waken up:
>>>>>>> - GIC distributor became disabled forever
>>>>>>> - scheduling is not performed any more
>>>>>>>
>>>>>>> Cc: Kevin Hilman <khilman@linaro.org>
>>>>>>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>>>>> Reported-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
>>>>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>>>
>>>>>> Applying into omap-for-v3.13/fixes thanks.
>>>>>
>>>>> Hmm looks like this breaks the build with randconfigs at least
>>>>> with the attached .config, so dropping for now.
>>>>
>>>> Hi Tony
>>>> Have you forgot to attach .config?
>>>
>>> Oops, sorry looks like I removed it already as I rebuilt the tree
>>> and started a new set of randconfig build tests.
>>>
>>>>> arch/arm/mach-omap2/built-in.o: In function `omap_enter_idle_coupled':
>>>>> :(.text+0xb48c): undefined reference to `pm44xx_errata'
>>>>
>>>> I assume that .config doesn't have CONFIG_SMP enabled while
>>>> pm44xx_errata is defined in omap-smp.c.
>>>> I think it should be a separate patch to move pm44xx_errata somewhere
>>>> else, so this patch will remain the same.
>>>
>>> Yes something like that probably. Sounds like that should be then
>>> patches before this fix.
>>>
>>>> Btw, do we need omap_enter_idle_coupled() in UP?
>>>
>>> That should be checked, am43xx may need it.
>>>
>> Nope. omap_enter_idle_coupled() is needed only for SMP
>> systems. UP don't need couple idle functionality as
>> such.
> 
> So what's the status of this fix and dependencies?
> 
> Both linux-next[1] and arm-soc/for-next[2] are failing boot tests on
> omap4460/panda-es because multi_v7_defconfig now has CPUidle enabled
> by default.
> 
I think Taras needs to refresh the patch based on discussion
and then it can be merged.

> 
> [1] http://lists.linaro.org/pipermail/kernel-build-reports/2014-January/001891.html
> [2] http://lists.linaro.org/pipermail/kernel-build-reports/2014-January/001898.html
> 

