Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbaCEChx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:37:53 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61240 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbaCEChu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:37:50 -0500
MIME-Version: 1.0
In-Reply-To: <53168976.7000008@wwwdotorg.org>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1393330950-7283-4-git-send-email-heikki.krogerus@linux.intel.com>
	<530D218E.9010007@wwwdotorg.org>
	<CACRpkdZF4-rWs1WkOp3t0x77fgSCE71E=wdrxiDuGZ8eBu_p_Q@mail.gmail.com>
	<53168976.7000008@wwwdotorg.org>
Date: Wed, 5 Mar 2014 10:37:50 +0800
Message-ID: <CACRpkdYfQoDmPX0He4J2Sn2wgQn2hHoHyPqnStLRVqrvi=M+-w@mail.gmail.com>
Subject: Re: [PATCHv2 3/5] net: rfkill: gpio: remove gpio names
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, Chen-Yu Tsai <wens@csie.org>,
        Rhyland Klein <rklein@nvidia.com>, Marc Dietrich <marvin24@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 10:18 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 03/04/2014 06:43 PM, Linus Walleij wrote:

>> If I understand the situation correctly it's like ACPI does not have named
>> GPIOs so keeping specifying this in DT GPIO bindings is counter-productive
>> to the work of abstracting the access to GPIO handlers so that drivers
>> need not know whether ACPI or DT is used for describing the hardware.
>
> For devices that already have both ACPI and DT bindings, we can't
> pretend they can be the same; they are already potentially different. We
> simply need to parse DT and ACPI differently, since that's the sway
> their bindings are defined.
>
> For any devices that don't have both ACPI and DT bindings, I agree we
> should certainly strive to make any new bindings aligned so we don't
> have to deal with this for them.
>
> However, we can't change the past.

Yeah, right, so for this very driver there are no bindings defined (yet)
and the only device tree I can find referencing it is the Tegra20-paz00
and it just use gpios = <>;

So in this case I think this patch is the right way forward, but I admit
I'm really uncertain in the general case.

Yours,
Linus Walleij
