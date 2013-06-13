Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3FML56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 07:57:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42601 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3FML55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 07:57:57 -0400
Date: Thu, 13 Jun 2013 12:56:40 +0100
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
Message-ID: <20130613115640.GC18614@n2100.arm.linux.org.uk>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856381-6644-1-git-send-email-srinivas.kandagatla@st.com> <CAHTX3d+dk3W_9b7SVUokWq4KYXnj=Z1=WPj5zJ-gUvJqqwE=+Q@mail.gmail.com> <51B5BCB3.3060405@st.com> <20130610231934.GG18614@n2100.arm.linux.org.uk> <51B6C8B7.50807@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B6C8B7.50807@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 07:50:31AM +0100, Srinivas KANDAGATLA wrote:
> You are right, It does not make sense to use BIT() macro for field which
> has more than 1 bit. I think using mix of both BIT() and the old style
> will make code look bit confusing to reader, Also no other mach code in
> the kernel use BIT while configuring L2 controller. So am going to drop
> the idea of using BIT here and leave the code as it is.

I'd suggest putting a comment in the code to that effect.  With the way
"cleanups" get done, I wouldn't be surprised if this attracts a lot of
people wanting to do a trivial "1 << bit" -> "BIT(bit)" conversions.

One of the problems of open source is that you can say "no" to a patch
like that until you're blue in the face, but it will eventually make
its way in via some path.

Just one of the reasons I consider BIT() to be evil and an inappropriate
macro.
