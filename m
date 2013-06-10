Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3FJXUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:20:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41535 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3FJXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:20:40 -0400
Date: Tue, 11 Jun 2013 00:19:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Michal Simek <monstr@monstr.eu>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH v2 06/11] ARM:stixxxx: Add STiH415 SOC support
Message-ID: <20130610231934.GG18614@n2100.arm.linux.org.uk>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856381-6644-1-git-send-email-srinivas.kandagatla@st.com> <CAHTX3d+dk3W_9b7SVUokWq4KYXnj=Z1=WPj5zJ-gUvJqqwE=+Q@mail.gmail.com> <51B5BCB3.3060405@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B5BCB3.3060405@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 12:46:59PM +0100, Srinivas KANDAGATLA wrote:
> >     +       aux_ctrl = (0x1 << L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT) |
> >     +               (0x1 << L2X0_AUX_CTRL_DATA_PREFETCH_SHIFT) |
> >     +               (0x1 << L2X0_AUX_CTRL_INSTR_PREFETCH_SHIFT) |
> >     +               (way_size << L2X0_AUX_CTRL_WAY_SIZE_SHIFT);
> > 
> > 
> > 
> > #include <linux/bitops.h>
> > Linus Walleij would write use  BIT() here
> 
> I will use BIT() macro.

Without checking those fields... BIT() is only appropriate if you're
really talking about single bits.  If you have a field of more than a
single bit which you happen to be setting to '1' then it's not
appropriate to use BIT().
