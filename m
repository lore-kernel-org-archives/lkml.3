Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaETSMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:12:01 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:44995 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaETSL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:11:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAJAp7OjUEkG9Wxg_ZhgAqRWQ9QE5sCnUHXW=Qsggq=OSprWLCQ@mail.gmail.com>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
	<7978295.UBGxYvcnvH@wuerfel>
	<CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
	<4435081.P3BKoakBJD@wuerfel>
	<CAJe_ZhfdcN8RBLgg02kN1hZ_j_JVSLM=2kEuYK+3DxqSiyCwgw@mail.gmail.com>
	<CAJAp7OjUEkG9Wxg_ZhgAqRWQ9QE5sCnUHXW=Qsggq=OSprWLCQ@mail.gmail.com>
Date: Tue, 20 May 2014 23:41:58 +0530
Message-ID: <CABb+yY3sR_uxqb68n2z0VNBe_MRMaym-16npq+D20cGvcqbHhQ@mail.gmail.com>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 1:25 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Mon, May 19, 2014 at 11:03 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>> On 19 May 2014 18:38, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Friday 16 May 2014 19:03:25 Jassi Brar wrote:
> [...]
>>> Do you have an example for a platform like that? I'd expect that normally
>>> we can have a boot loader that sets up the system timer to work good
>>> enough for us to get into normal driver initialization.
>>>
>> My platform. We choose to keep bootloader to the minimum and make
>> kernel not depend upon any goodies provided.
>> Second, which I don't think can be helped by a bootloader, the remote
>> master has gate & rate control of clocks to peripheral IPs. The
>> clk-api driver simply maps Linux requests onto mailbox commands. So
>> the mailbox is needed as early as CLK_OF_DECLARE (when kernel reads
>> the rate of every registered clock).   Any suggestions?
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
>
As Arnd suspected, my clocksource SP804's clk as well is owned by the remote.
Another situation (again my platform) where EPROBE_DEFER won't help is
when CPU reset control is with the remote because smp_init() trumps
even a core_initcall.

Regards,
Jassi
