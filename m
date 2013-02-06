Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3BFRH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:07:56 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:54939 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3BFRHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <9348609.HjKCmL9u9S@wuerfel>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
	<1357764194-12677-7-git-send-email-thierry.reding@avionic-design.de>
	<CACRpkdYV5w6BksUjXvXs=88BovUyXgRt-vXSD0twjRpzbZcvFQ@mail.gmail.com>
	<9348609.HjKCmL9u9S@wuerfel>
Date: Wed, 6 Feb 2013 18:07:53 +0100
Message-ID: <CACRpkdYGgdMTi0ZeMeCk5UmrndD451Pyz8L_XE=y9SPXfGGdew@mail.gmail.com>
Subject: Re: [PATCH 06/14] ARM: pci: Keep pci_common_init() around after init
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-tegra@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 1:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 06 February 2013 17:38:20 Linus Walleij wrote:
>> On Wed, Jan 9, 2013 at 9:43 PM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>>
>> > When using deferred driver probing, PCI host controller drivers may
>> > actually require this function after the init stage.
>> >
>> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>>
>> There seem to be a proliferation of these patches now.
>>
>> Isn't this just papering over the real problem? The discarding
>> of __init sections need to happen *after* all deferred probes
>> are complete, lest we have to remove *all* __init sections from
>> *all* drivers in the kernel, don't we?
>
> No, I think it's not quite that bad. I think the rule is still
> just that .probe() functions and anything called from them must
> not be __init. They used to be __devinit, which would cause
> problems with deferred probing on !HOTPLUG systems but that's
> gone in 3.9.
>
> Thierry's patch is just necessary because pci_common_init used
> to be called only from actual __init functions, and not it
> gets called from a .probe() function for the first time.

Aha OK, then it feels much better now.

However it leaves the question of how much __init, __initdata
and __initconst we have littering around. Oh, well, we'll see
I guess.

Thanks,
Linus Walleij
