Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbbAIMQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:16:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26063 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbbAIMQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:16:50 -0500
Date: Fri, 9 Jan 2015 20:13:06 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "antoine.tenart@free-electrons.com" 
	<antoine.tenart@free-electrons.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] clk: berlin: bg2q: remove non-exist "smemc" gate
 clock
Message-ID: <20150109201306.4d1a296b@xhacker>
In-Reply-To: <54AD431F.6060403@gmail.com>
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com>
	<1420016272-6789-4-git-send-email-jszhang@marvell.com>
	<54AD3EAE.6090009@gmail.com>
	<20150107222209.64ed24a0@xhacker>
	<54AD431F.6060403@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-09_04:2015-01-09,2015-01-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501090104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian,

On Wed, 7 Jan 2015 06:30:55 -0800
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> On 07.01.2015 15:22, Jisheng Zhang wrote:
> > Dear Sebastian,
> >
> > On Wed, 7 Jan 2015 06:11:58 -0800
> > Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
> >
> >> On 31.12.2014 09:57, Jisheng Zhang wrote:
> >>> The "smemc" clock is removed on BG2Q SoCs. In fact, bit19 of clkenable
> >>> register is for nfc. Current code use bit19 for non-exist "smemc"
> >>> incorrectly, this prevents eMMC from working due to the sdhci's
> >>> "core" clk is still gated.
> >>>
> >>> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> >>> Cc: stable@vger.kernel.org # 3.16+
> >>> ---
> >>>    drivers/clk/berlin/bg2q.c | 1 -
> >>>    1 file changed, 1 deletion(-)
> >>>
> >>> diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
> >>> index 21784e4..440ef81 100644
> >>> --- a/drivers/clk/berlin/bg2q.c
> >>> +++ b/drivers/clk/berlin/bg2q.c
> >>> @@ -285,7 +285,6 @@ static const struct berlin2_gate_data bg2q_gates[]
> >>> __initconst = { { "pbridge",	"perif",	15,
> >>> CLK_IGNORE_UNUSED }, { "sdio",	"perif",	16,
> >>> CLK_IGNORE_UNUSED }, { "nfc",	"perif",	18 },
> >
> > The nfc here is really confusing, we call it as nfccore internally. Is it
> > better to rename it as nfccore?
> 
> I guess it comes from some early Marvell BSP code, if there is no
> issues with the name, e.g. something already depends on "nfc", feel
> free to rename it to something more meaningful.

In BG2, mrvl call the clock as nfccore. The code use "nfc" for it.
The situation is similar for usbcore, satacore etc. So keep the name here,
what do you think?

> 
> >>> -	{ "smemc",	"perif",	19 },
> >>
> >> Jisheng,
> >>
> >> if bit 19 is for nfc, how does that work out with bit 18 which is
> >> still assigned to nfc? Can you re-evaluate clkenable registers for
> >
> > bit 19 is for nfcEcc, the "io" clock; bit 18 is for nfcCore, the "core"
> > clock.
> 
> Ok, then both bits should be dealt with accordingly, i.e. rename
> "smemc" to "nfcecc" and use it in the corresponding dts node.
> 
> If this clk_gate just disables a clock that is fed into another
> gateable clock module, I can live with removing it - although I
> still think it is best to leave the clk_gate in place and pick
> another name that does not collide with any other clock name.

The nfcecc is already defined in the bg2q_divs, the gate bit is correct there.

> 
> >> BG2Q and fix it up accordingly? I'd suggest to still disable as many
> >
> > I'll recheck the clk driver for BG2Q.
> 

I checked the clk driver for BG2Q one by one. The only problem is the "smemc"
issue. Removing it is the only thing we need to do. So I think we can use the
patch I sent.

Thanks,
Jisheng
