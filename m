Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaKUBa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:30:59 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44419 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbaKUBa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:30:56 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>
	<1709760.E0jX3Myv0h@wuerfel> <546C7FDD.7030906@ti.com>
	<2900095.WIocOu7ue2@wuerfel>
	<CAPDyKFqeZ3YU2OEN4tCOdcQ0pAho67Q8U_eCEOroG9aS0mp+-Q@mail.gmail.com>
	<546DD87B.3080806@ti.com>
	<CAPDyKFrBhZyqozM98_4pPdW0EMFt5W6VX1X7cz6Z=yNhW4vYTA@mail.gmail.com>
	<CAMuHMdWtHT7QX3Kpa-GCLa49ToGODwjnNVgfxDzJzcM-FU1ffg@mail.gmail.com>
	<546E0970.5090301@ti.com> <7hh9xtr5ac.fsf@deeprootsystems.com>
	<CAMuHMdV7zASj8_NtLRir1VubXEKTkq0vBGMXeYXDACu8UC2tZA@mail.gmail.com>
	<7hbno1r1af.fsf@deeprootsystems.com>
	<CAMuHMdVXGPu7x706NxqO3rn3KuRbPbD_ZQsJtDH4Hf31AaRR+Q@mail.gmail.com>
Date: Thu, 20 Nov 2014 17:30:53 -0800
In-Reply-To: <CAMuHMdVXGPu7x706NxqO3rn3KuRbPbD_ZQsJtDH4Hf31AaRR+Q@mail.gmail.com>
	(Geert Uytterhoeven's message of "Thu, 20 Nov 2014 22:54:07 +0100")
Message-ID: <7hppchpcfm.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Thu, Nov 20, 2014 at 10:48 PM, Kevin Hilman <khilman@kernel.org> wrote:
>>>> So what exactly are we talking about with "PM" clocks, and why are they
>>>> "special" when it comes to PM domains?  IOW, why are the clocks to be
>>>> managed during PM domain transitions for a given device any different
>>>> than the clocks that need to be managed for a runtime suspend/resume (or
>>>> system suspend/resume) sequence for the same device?
>>>
>>> (Speaking for my case, shmobile)
>>>
>>> They're not. The clocks to be managed during PM domain transitions are the
>>> same as the clocks that need to be managed for a runtime suspend/resume
>>> (or system suspend/resume) sequence.
>>>
>>> The special thing is that this is more a platform than a driver thing: the same
>>> module may have a "PM/functional" clock (that is documented to enable/disable
>>> the module) on one Soc, but noet on another.
>>
>> So why isn't the presence or absence of the clock described in the .dtsi
>> for the SoC instead of being handled by special PM domain logic?
>
> It is. Cfr. the presence/absence of clocks for renesas,rcar-gpio nodes.

Hmm, OK, Good.  

So now I'm confused about why the PM domain has to do anything special
if the presence/absence of the clocks is already handled by the DT.

Kevin



