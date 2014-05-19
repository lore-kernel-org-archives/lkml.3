Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbaESUCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:02:07 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60089 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaESUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:02:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
Date: Mon, 19 May 2014 22:01:36 +0200
Message-ID: <5908149.zGas12hmDq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJAp7OjUEkG9Wxg_ZhgAqRWQ9QE5sCnUHXW=Qsggq=OSprWLCQ@mail.gmail.com>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org> <CAJe_ZhfdcN8RBLgg02kN1hZ_j_JVSLM=2kEuYK+3DxqSiyCwgw@mail.gmail.com> <CAJAp7OjUEkG9Wxg_ZhgAqRWQ9QE5sCnUHXW=Qsggq=OSprWLCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+Dh3oEpOYL5topMy72tql7/uXqxg5mq9DH3hOdrKjtf
 VoIRmJvmLoEwCDQ3ta13gZ6ZgUrNjPKmnJPM9x4beGGOMGfSUm
 EVQ1Fr4M1BQSjhhhjGsBMYuw7nevjDLJJAFkYuNzlQraj/YEMu
 EAGOdCDsV18+LDaIVtROICvWMfHPpEWmD4YOSbC1Sdn/D99dqG
 lX+0uldryKwPnye4KHSViOknrM5SwSes8HbvGW88ec46N5vaaG
 Od+dThJcZMd02CswSyC+3n6IA4QYhZMByedh9IHr/bwiVcfOWP
 +B7W/xT38ipTypv/qx505a1WCL0jnPmnFiDhNg/iy+xjJErTnQ
 V1o8xm1jfOHv5w+LLrZs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 12:55:51 Bjorn Andersson wrote:
> On Mon, May 19, 2014 at 11:03 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> > On 19 May 2014 18:38, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Friday 16 May 2014 19:03:25 Jassi Brar wrote:
> [...]
> >> Do you have an example for a platform like that? I'd expect that normally
> >> we can have a boot loader that sets up the system timer to work good
> >> enough for us to get into normal driver initialization.
> >>
> > My platform. We choose to keep bootloader to the minimum and make
> > kernel not depend upon any goodies provided.
> > Second, which I don't think can be helped by a bootloader, the remote
> > master has gate & rate control of clocks to peripheral IPs. The
> > clk-api driver simply maps Linux requests onto mailbox commands. So
> > the mailbox is needed as early as CLK_OF_DECLARE (when kernel reads
> > the rate of every registered clock).   Any suggestions?
> 
> Hi Jessi
> 
> On the newer Qualcomm platform the root clocks are controlled by a "resource
> power manager" system; all clocks and regulators accesses are done over a fifo
> based communication link, over shared memory, with dependencies on e.g.
> hwspinlocks.
> 
> There's nothing strange with this, you just have to bring up (probe) all those
> drivers before you can initialize the clock driver so that you can
> initialize any
> peripheral device drivers. That's what you have EPROBE_DEFER for.
> 
> 
> Even in your sparsely initialized system, you must have enough clocks to
> bring up the mailbox driver, so that you can bring up your clock driver and
> from that you're good to initialize the rest.

The one dependency that is really hard to avoid is usually the clocksource.
If you can't enable that early, you don't get into the normal driver probe
and need some hack instead.

	Arnd
