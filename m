Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbaCEC70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:59:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49666 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbaCEC7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:59:23 -0500
Message-ID: <53169304.9080002@wwwdotorg.org>
Date: Tue, 04 Mar 2014 19:59:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
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
Subject: Re: [PATCHv2 3/5] net: rfkill: gpio: remove gpio names
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>	<1393330950-7283-4-git-send-email-heikki.krogerus@linux.intel.com>	<530D218E.9010007@wwwdotorg.org>	<CACRpkdZF4-rWs1WkOp3t0x77fgSCE71E=wdrxiDuGZ8eBu_p_Q@mail.gmail.com>	<53168976.7000008@wwwdotorg.org> <CACRpkdYfQoDmPX0He4J2Sn2wgQn2hHoHyPqnStLRVqrvi=M+-w@mail.gmail.com>
In-Reply-To: <CACRpkdYfQoDmPX0He4J2Sn2wgQn2hHoHyPqnStLRVqrvi=M+-w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 07:37 PM, Linus Walleij wrote:
> On Wed, Mar 5, 2014 at 10:18 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 03/04/2014 06:43 PM, Linus Walleij wrote:
> 
>>> If I understand the situation correctly it's like ACPI does not have named
>>> GPIOs so keeping specifying this in DT GPIO bindings is counter-productive
>>> to the work of abstracting the access to GPIO handlers so that drivers
>>> need not know whether ACPI or DT is used for describing the hardware.
>>
>> For devices that already have both ACPI and DT bindings, we can't
>> pretend they can be the same; they are already potentially different. We
>> simply need to parse DT and ACPI differently, since that's the sway
>> their bindings are defined.
>>
>> For any devices that don't have both ACPI and DT bindings, I agree we
>> should certainly strive to make any new bindings aligned so we don't
>> have to deal with this for them.
>>
>> However, we can't change the past.
> 
> Yeah, right, so for this very driver there are no bindings defined (yet)
> and the only device tree I can find referencing it is the Tegra20-paz00
> and it just use gpios = <>;
> 
> So in this case I think this patch is the right way forward, but I admit
> I'm really uncertain in the general case.

If there are no bindings defined at all yet, then we can define both DT
and ACPI bindings to use name-based GPIOs. Index-based lookups aren't a
good way forward.

