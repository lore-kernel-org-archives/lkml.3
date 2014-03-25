Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaCYUYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:24:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaCYUYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:24:17 -0400
Message-ID: <5331E5EB.5000304@biereigel-wb.de>
Date: Tue, 25 Mar 2014 21:24:11 +0100
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>,
        Lan Tianyu <lantianyu1986@gmail.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Stefan Biereigel <stefan@biereigel.de>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, San Zamoyski <san@plusnet.pl>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        "D. Jansen" <dennis.jansen@web.de>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>
Subject: Re: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after
 suspend to RAM.
References: <532FE3B2.9060808@biereigel-wb.de> <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com> <533014B1.4030307@biereigel-wb.de> <CAOLK0pyOV50Vqt+bX_QpH_tjL=8eWwvu+O70EvTOZ+ixWZmr3Q@mail.gmail.com> <CAGf84Q+9RcQqi=YYvF8X8EJzbtk7dJYTxScaZN4347U+POQ4AQ@mail.gmail.com>
In-Reply-To: <CAGf84Q+9RcQqi=YYvF8X8EJzbtk7dJYTxScaZN4347U+POQ4AQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:UxHEhVraH1NUJmLlaoxVpQE1X9sF3DCl+qP679pTGrN
 6zE8dV05X7c7K4Fu/fkQn8SfYJPCwqQD+8ZsA+6bylBpOvDeGP
 jA9qqRe1QdqhVpCVSu9Jp6Bgq34EQTWDiaV9Fa8EnwfEpZsjWB
 T/C6EaqBQ5tTSkbWOB14dw+D9HM7+a4kgZoPEsnGv/6KcEv0QL
 3hC2tf2SHGOcWZl439jASTYg/2+e+FjNPvLgVMCCsEKTmEMcEp
 P2scfiPTvxIkSsgU/ncpBWh2DB8AyScet2+Ue0YVE10j2ycErm
 tUgc7BXQYNSAIZ15Veoqn759OQsUuSuloNQrura6TDCnlxZcIj
 yociFDJI2S8eTfVf1JWM1jtweP1eZpdhe9BqSKHs5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alright - as I have some spare time tonight, here is the dmesg of one
sleep/resume cycle on an unpatched 3.14-rc8 tree with my usual config +
dynamic debug enabled. After resuming, lid state was still "closed", so
the bug was triggered (and the stale event is removed as stated).

http://pastebin.ca/2679209

You can find the "EC: 1 stale EC events cleared" Line @ Line 316. I
really did not expect that much traffic from the EC, interesting to get
some insight into that!

Regarding other actions: The system notices removal of the AC cord when
in sleep (xfce4-power-manager reports the correct symbol after the
wakeup), so I guess this is working as it should (as it is handled by
the _WAK-Routine??).

Hope that helps!
Stefan


Am 25.03.2014 14:23, schrieb Kieran Clancy:
> On Tue, Mar 25, 2014 at 8:04 PM, Lan Tianyu <lantianyu1986@gmail.com> wrote:
>> 2014-03-24 19:19 GMT+08:00 Stefan Biereigel <security@biereigel-wb.de>:
>>> Hi,
>>> thank you for the suggestion. The patch resolves the issue on my N150
>>> when applied to a clean 3.14-rc7. Anyways I'm wondering if similar
>>> problems to mine now exist on the Samsung Series 7/9 notebooks?
>>>
>>> Is any further action from my part required?
>>
>> Do you have these machines? If yes, please provide the output of
>> dmidecode command.
>>
>> Cc guys  of commit ad332c8a.
> 
> Hi guys,
> 
> That's a surprising side-effect, although I guess I shouldn't be
> surprised by Samsung ACPI weirdness anymore.
> 
> If we can, I'd like to get to the bottom of this rather than just turn
> off this fix (which we know works for series 5, 7 and 9 without
> problems).
> 
>>>> 2014-03-24 15:50 GMT+08:00 Stefan Biereigel <security@biereigel-wb.de>:
>>>>> Hi,
>>>>>
>>>>> starting with 3.14-rc6, the lid on my Samsung N150 behaves weird: My
>>>>> system is set up, so that it should suspend to RAM as soon as the lid is
>>>>> closed. Beginning with 3.14-rc6, the lid goes from "open" to "closed"
>>>>> correctly the first time (and the system suspends), but after resuming
>>>>> from standby (by opening the lid), the lid does not change to "open" again.
>>>>> Of course, closing the lid again does not induce suspend to RAM then.
>>>>> Opening the lid now (while not sleeping), makes ACPI notify the opening,
>>>>> so I guess ACPI "misses" or discards the lid open event from the EC when
>>>>> coming from sleep.
>>>>> Now, closing the lid again does induce suspend to RAM. This behaviour is
>>>>> reproducible: every other time, suspending works.
>>>>>
>>>>> This behaviour seems to be introduced by commit ad332c8a: ACPI / EC:
>>>>> Clear stale EC events on Samsung systems.
>>>>> Which was introduced after 3.14-rc5.
>>>>>
>>>>> When opening the lid to resume from standby, i see in dmesg:
>>>>> Mar 23 22:12:04 little1 kernel: [ 7630.932074] ACPI : EC: 1 stale EC
>>>>> events cleared
>>>>> (which comes from drivers/acpi/ec.c)
>>>>>
>>>>> Seems to me, that the "open" event is cleared from the EC, but also
>>>>> discarded instead of passed on. Shouldn't the correct behaviour be to
>>>>> report all the pending events, read from the EC, as ACPI events? Can you
>>>>> point me in a direction for fixing the issue cleanly, then I will try to
>>>>> find a solution and prepare a patch for this issue.
> 
> Stefan, thank you for reporting this issue.
> 
> Our rationale for discarding the events was that events queued during
> sleep are probably no longer relevant. There could also be other
> unwanted side-effects of blindly executing all of the old
> instructions. But in your case, this assumption might be wrong.
> 
> What command are you using to check if the lid is "open" or "closed"?
> Is it because the screen is not waking up, or some other effect, or
> just because it won't suspend again when it's re-closed?
> 
> Do other events like AC plug/unplug affect any of this if you do them
> during this bad state?
> 
> I'd like to see exactly which EC command byte is being thrown away
> here. If you do something like this (with dynamic debug enabled)
> 
> echo -n 'file ec.c +p' | sudo tee /sys/kernel/debug/dynamic_debug/control
> 
> You should get massively verbose EC stuff filling your dmesg, but I am
> just interested in the EC read/write bytes just before and around the
> "1 stale EC events cleared" message. Grab this out of dmesg before it
> fills with other stuff.
> 
> This will tell us what command we are being asked to run. If you can,
> please do it a few times to see if it's the same command each time or
> something different.
> 
> You can turn the debug output off again with:
> 
> echo -n 'file ec.c -p' | sudo tee /sys/kernel/debug/dynamic_debug/control
> 
> I might also need a copy of your DSDT, if you can send me that
> separately in another email (not to the list):
> 
> cat /sys/firmware/acpi/tables/DSDT > .DSDT.aml
> 
> Thank you,
> Kieran.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
