Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaAVO5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:57:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaAVO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:57:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
Date: Wed, 22 Jan 2014 15:56:05 +0100
Message-ID: <3140612.0s75qS6VKb@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140122114616.GB15591@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <52DCE790.6080809@linaro.org> <20140122114616.GB15591@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ltRL2FnPYC7NlYqF91kbn6MQn3jf8jxzMkUfbx+9ZFg
 8441Q4AATpCGShbOd6JFXntR4RPb+pciAKihUfIty1oUSzYJk6
 WygTsPV7ywlyWRP+EbUOxyYLlPuS4KE2LgdV+/X0BDnqsWS9VO
 HNjxLBaF5afVEzxxa4eGUCtSeYpR8eiFh+ux/Jsr8awXm8Fqme
 g5EX1iU/HeablQsAhWjftlEbMTxJO9pcEWDiTbLyo4KayYmA+Y
 KS3X8uooAro4zXKYsRlWNlQWOvb14uPHXCnA672+ZL1kr418B1
 8OhYw1mA6NQxKFVxrfaZNPi6q6rZSWU4bITj077flqv1DHWfiu
 iR44PEJmRba8/H2x30pY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 January 2014 11:46:16 Mark Rutland wrote:
> On Mon, Jan 20, 2014 at 09:08:32AM +0000, Hanjun Guo wrote:
> > On 2014-1-17 22:21, Arnd Bergmann wrote:
> > > On Friday 17 January 2014, Hanjun Guo wrote:
> > >>
> > >> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > >>
> > >> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
> > >> name from the ACPI timer table is matched with all the registered
> > >> timer controllers and matching initialisation routine is invoked.
> > > 
> > > I wouldn't anticipate this infrastructure to be required. Shouldn't all
> > > ARMv8 machines have an architected timer?
> > 
> > I not sure of this, could anyone can give some guidance? if only arch
> > timer is available for ARM64, this will make thing very simple.
> 
> All ARMv8 systems should have an architected timer.
> 
> However, they may also have other timers (e.g. global timers for use
> when CPUs are in low power states and their local architected timers
> aren't active).

But all other timers could be regular platform drivers I suppose. No
need for special infrastructure for those.

	Arnd
