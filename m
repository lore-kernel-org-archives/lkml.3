Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3FMMra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:47:30 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36781 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3FMMr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130610231934.GG18614@n2100.arm.linux.org.uk>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
	<1370856381-6644-1-git-send-email-srinivas.kandagatla@st.com>
	<CAHTX3d+dk3W_9b7SVUokWq4KYXnj=Z1=WPj5zJ-gUvJqqwE=+Q@mail.gmail.com>
	<51B5BCB3.3060405@st.com>
	<20130610231934.GG18614@n2100.arm.linux.org.uk>
Date: Thu, 13 Jun 2013 14:47:27 +0200
Message-ID: <CACRpkdaiPubGw5t8xN+aVXkZBJNuLfPbxEFOkp+u14NtzRyTAw@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] ARM:stixxxx: Add STiH415 SOC support
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Michal Simek <monstr@monstr.eu>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 1:19 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 10, 2013 at 12:46:59PM +0100, Srinivas KANDAGATLA wrote:
>> >     +       aux_ctrl = (0x1 << L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT) |
>> >     +               (0x1 << L2X0_AUX_CTRL_DATA_PREFETCH_SHIFT) |
>> >     +               (0x1 << L2X0_AUX_CTRL_INSTR_PREFETCH_SHIFT) |
>> >     +               (way_size << L2X0_AUX_CTRL_WAY_SIZE_SHIFT);
>> >
>> >
>> >
>> > #include <linux/bitops.h>
>> > Linus Walleij would write use  BIT() here
>>
>> I will use BIT() macro.
>
> Without checking those fields... BIT() is only appropriate if you're
> really talking about single bits.  If you have a field of more than a
> single bit which you happen to be setting to '1' then it's not
> appropriate to use BIT().

This is true. Luckily I didn't push for it myself this time.

However, on a related key we have this hidden away in MFD
drivers/mfd/dbx500-prcmu-regs.h:

#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))

It's used like so:

#define PRCM_PLL_FREQ_D_MASK    BITS(0, 7)

So you can define an multi-bit mask with a macro like that.

If there is interest in a construct like this I can make a patch to
move this thing to <linux/bitops.h>.

Yours,
Linus Walleij
