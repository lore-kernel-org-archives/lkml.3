Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaESSDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:03:18 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57074 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaESSDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:03:00 -0400
MIME-Version: 1.0
In-Reply-To: <4435081.P3BKoakBJD@wuerfel>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
	<7978295.UBGxYvcnvH@wuerfel>
	<CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
	<4435081.P3BKoakBJD@wuerfel>
Date: Mon, 19 May 2014 23:33:00 +0530
Message-ID: <CAJe_ZhfdcN8RBLgg02kN1hZ_j_JVSLM=2kEuYK+3DxqSiyCwgw@mail.gmail.com>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
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

On 19 May 2014 18:38, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 16 May 2014 19:03:25 Jassi Brar wrote:

>
>>  Also, some platform might need to communicate with remote master
>> during very early boot like for initializing system timers and clocks.
>> The API isn't working then.
>
> Do you have an example for a platform like that? I'd expect that normally
> we can have a boot loader that sets up the system timer to work good
> enough for us to get into normal driver initialization.
>
My platform. We choose to keep bootloader to the minimum and make
kernel not depend upon any goodies provided.
Second, which I don't think can be helped by a bootloader, the remote
master has gate & rate control of clocks to peripheral IPs. The
clk-api driver simply maps Linux requests onto mailbox commands. So
the mailbox is needed as early as CLK_OF_DECLARE (when kernel reads
the rate of every registered clock).   Any suggestions?

Thanks
Jassi
