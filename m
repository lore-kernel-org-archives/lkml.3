Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaIJMeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:34:09 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:37312 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaIJMeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <540F0381.7010500@ti.com>
References: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
	<7hr3zln692.fsf@linaro.org>
	<540F0381.7010500@ti.com>
Date: Wed, 10 Sep 2014 14:34:02 +0200
X-Google-Sender-Auth: Q4KbDUOUj8hMKZOG8RlUZ40dBlE
Message-ID: <CAMuHMdXRx6QUs2zhsXXz6aia0=v521+_B4NR61JVv61aWnwyPw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] PM / clock_ops: allow to specify custom
 pm_clk_notifier callback
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On Tue, Sep 9, 2014 at 3:41 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>>> Also, It updates Keystone 2 platform code to provide custom
>>> callback which fills list of clocks for Device with all clocks assigned to this
>>> Device in DT.
>>> More over, It's safe for Keystone 2 to perform CLK PM domain initialization
>>> at device's binding time instead of device's creation time.
>>>
>>> I've posted these patches because I need fully enable Runtime PM on Keystone 2
>>> where all HW modules are controlled using clocks only. That's why CLK PM domain
>>> fits our needs perfectly.
>>
>> Heh, doesn't seem like a perfect fit to me ;)
>>
>>> Also, on Keystone 2 clocks are initialized early and
>>> they are available at device creation time. The main problems from my side are:
>>>   - every time when support for new HW modules is added the ".con_ids" array
>>>     need to be checked and updated;
>>>   - restriction for clock's names in DT - to be named using only above con_ids
>>>     It's ugly.
>>>
>>> I hope, this approach to be accepted at least as temporal solution until
>>> the generic solution is not found.
>>
>> Sorry if I missed it, but is there ongoing discussion of a more generic
>> solution other than this one:
>
> Yep. :( But It's ongoing more than 2 months already and seems there is no
> light at the end of tunnel.
>
>>
>>> [1] Previously, same problem was discussed in, but no final solution was accepted:
>>>   "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
>>>   https://lkml.org/lkml/2014/4/24/1118
>>
>> Personally, I still like Geert's approach better.
>>
>
> Unfortunately, Geert is not going to continue working on it (as I know).

For the record, I had postponed working on it, as we had an interim solution for
multiplatform shmobile being broken in mainline (drivers/sh/pm_runtime.c).

Currently I'm tackling "real" power domains. As this is incompatible with
the above hack (you can attach only one power domain to a device, as Ulf
had pointed out before --- Hm, why is the DT property called "power-domains"
(plural) then?), I'll have to revisit anyway, and get back to it.
Furthermore, not all shmobile SoCs have such fine-grained power domains
as sh7372/sh73a0/r8a7740/r8a73a4, so we still need something better there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
