Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbaKTUWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:22:25 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55562 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaKTUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:22:23 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
	<546E0970.5090301@ti.com>
Date: Thu, 20 Nov 2014 12:22:19 -0800
In-Reply-To: <546E0970.5090301@ti.com> (Grygorii Strashko's message of "Thu,
	20 Nov 2014 17:32:00 +0200")
Message-ID: <7hh9xtr5ac.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> On 11/20/2014 03:32 PM, Geert Uytterhoeven wrote:
>> On Thu, Nov 20, 2014 at 2:12 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

[...]

>>> So I really think we need to decide on how to address the split of the
>>> device clocks. Before that's done, I don't think it make sense to add
>>> a "simple-pmdomain" compatible, since it will likely not be that many
>>> SoC that can use it.
>>>
>>> So, does anyone have a suggestion on how to deal with the split of the
>>> device clocks into "functional" clocks and into "PM" clocks?
>
> Would it be better to say "functional" and "optional"? In my opinion
> "PM" == "functional". Also, such clock's separation is used in TRM/DM/UMs on HW.

Yes!  I really don't like the name "PM" clock, since it's not at all
obvious what that means.  To me, "PM" == "functional" as well.

So what exactly are we talking about with "PM" clocks, and why are they
"special" when it comes to PM domains?  IOW, why are the clocks to be
managed during PM domain transitions for a given device any different
than the clocks that need to be managed for a runtime suspend/resume (or
system suspend/resume) sequence for the same device?

Kevin
