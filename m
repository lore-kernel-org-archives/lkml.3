Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaKLRHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:07:24 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:36408 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaKLRHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:07:22 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:5c0e:7567:d831:6fad]
In-Reply-To: <20141112122017.GC30821@ulmo.nvidia.com>
References: <1415738970-7963-1-git-send-email-olof@lixom.net>
	<20141112122017.GC30821@ulmo.nvidia.com>
Date: Wed, 12 Nov 2014 09:07:20 -0800
Message-ID: <CAOesGMjmVJuaiFZf6msFtsGiQn6TOPatZ7V3p-KfaPqpXnrYmA@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: tegra: move serial aliases to per-board
From: Olof Johansson <olof@lixom.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        gregkh@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,



On Wed, Nov 12, 2014 at 4:20 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Nov 11, 2014 at 12:49:30PM -0800, Olof Johansson wrote:
>> There are general changes pending to make the /aliases/serial* entries
>> number the serial ports on the system. On tegra, so far the ports have been
>> just numbered dynamically as they are configured so that makes them change.
>>
>> To avoid this, add specific aliases per board to keep the old numbers. This
>> allows us to change the numbering by default on future SoCs while keeping the
>> numbering on existing boards.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>
>> Stephen/Thierry/Alex, as noticed this week we really should try to get
>> this in before the 3.19 merge window so that the global aliases change
>> can happen there without regression.
>>
>> If you have more fixes queued up, feel free to add this to the next pull
>> request. If not, a review and ack would be appreciated.
>>
>>  arch/arm/boot/dts/tegra114-dalmore.dts        |    1 +
>>  arch/arm/boot/dts/tegra114-roth.dts           |    4 ++++
>>  arch/arm/boot/dts/tegra114-tn7.dts            |    4 ++++
>>  arch/arm/boot/dts/tegra114.dtsi               |    7 -------
>>  arch/arm/boot/dts/tegra124-jetson-tk1.dts     |    1 +
>>  arch/arm/boot/dts/tegra124-nyan-big.dts       |    1 +
>>  arch/arm/boot/dts/tegra124-venice2.dts        |    1 +
>>  arch/arm/boot/dts/tegra124.dtsi               |    7 -------
>>  arch/arm/boot/dts/tegra20-harmony.dts         |    1 +
>>  arch/arm/boot/dts/tegra20-iris-512.dts        |    5 +++++
>>  arch/arm/boot/dts/tegra20-medcom-wide.dts     |    4 ++++
>>  arch/arm/boot/dts/tegra20-paz00.dts           |    2 ++
>>  arch/arm/boot/dts/tegra20-seaboard.dts        |    1 +
>>  arch/arm/boot/dts/tegra20-tamonten.dtsi       |    1 +
>>  arch/arm/boot/dts/tegra20-trimslice.dts       |    1 +
>>  arch/arm/boot/dts/tegra20-ventana.dts         |    1 +
>>  arch/arm/boot/dts/tegra20-whistler.dts        |    1 +
>>  arch/arm/boot/dts/tegra20.dtsi                |    8 --------
>>  arch/arm/boot/dts/tegra30-apalis-eval.dts     |    4 ++++
>>  arch/arm/boot/dts/tegra30-beaver.dts          |    1 +
>>  arch/arm/boot/dts/tegra30-cardhu.dtsi         |    2 ++
>>  arch/arm/boot/dts/tegra30-colibri-eval-v3.dts |    3 +++
>>  arch/arm/boot/dts/tegra30.dtsi                |    8 --------
>>  23 files changed, 39 insertions(+), 30 deletions(-)
>
> I have applied this to the for-3.19/dt branch.

Maybe I wasn't entirely clear -- I was proposing to include this in
the next batch of fixes for 3.18 so that the aliases processing code
can go in for 3.19. If we hold this until the merge window we run the
risk of having largeish parts of the merge window unbisectable (more
than if we merge this as part of the next/dt contents).

> So for anything that is
> post Tegra124 the new rule shall be to add aliases to the SoC .dtsi and
> then use consistent numbering of UART ports across boards?
>
> The alternative is to remain consistent with what this patch does, which
> would be to make the serial port numbering a property of the board. That
> doesn't sound too bad to me either since it'll hide all the unused ports
> on a given board.

I was envisioning the former, but the latter would work OK too.


-Olof
