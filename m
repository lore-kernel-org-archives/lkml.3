Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaL3K3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:29:14 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:49712 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaL3K3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:29:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UCyOXfMqu_MYbd5pKOpgXPB87LQ7hCegeeY9vzsy6QAg@mail.gmail.com>
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
	<CAPDyKFpxvE4x_-PV=KN0HKY5cNug-ss9m5KCjNdebR1LDOJi5w@mail.gmail.com>
	<CAD=FV=UCyOXfMqu_MYbd5pKOpgXPB87LQ7hCegeeY9vzsy6QAg@mail.gmail.com>
Date: Tue, 30 Dec 2014 11:29:10 +0100
Message-ID: <CAPDyKFqGW2NaN+5mUrpBWrhM5ZfUSx70-Yyk9qmNaC1ft_ibpw@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Fixes for SDIO interrupts for dw_mmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Tony Lindgren <tony@atomide.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>,
        Joe Perches <joe@perches.com>, Axel Lin <axel.lin@ingics.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 December 2014 at 20:02, Doug Anderson <dianders@chromium.org> wrote:
> Ulf,
>
> On Fri, Dec 19, 2014 at 2:17 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 3 December 2014 at 00:42, Doug Anderson <dianders@chromium.org> wrote:
>>> Bing Zhao at Marvell found a problem with dw_mmc where interrupts
>>> weren't firing sometimes.  He tracked it down to a read-modify-write
>>> problem with the INTMASK.  These patches fix the problem.
>>>
>>> Note: I've picked up a > 1-year old series here to make another
>>> attempt at landing it upstream.  These patches have been in shipping
>>> Chromebooks for the last year.  Note that v3 to v4 has no changes
>>> other than a rebase and a small commit message update.
>>>
>>> The first two patches extend the "init_card()" mechanism of MMC core
>>> to actually be called for all card types, not just SDIO.  That could
>>> be applied any time and should fix at least one longstanding bug
>>> (untested).
>>>
>>> The third patch is a cleanup patch to use init_card() to move things
>>> around a bit so we don't need to handle SDIO cards in such a strange
>>> place.  On earlier versions of this patch Seungwon brought up a few
>>> points which I have _not_ addressed.  See
>>> <https://patchwork.kernel.org/patch/3049071/>.  Other than talk of
>>> cards with out of band interrupts maybe being able to gate their
>>> clocks, he wanted to use MMC_QUIRK_BROKEN_CLK_GATING.  I didn't do
>>> that because of the ordering of init_card() and when the quirks are
>>> set.  Some users of init_card() like pandora_wl1251_init_card() rely
>>> on it being called very early in the process.
>>> pandora_wl1251_init_card() hardcodes a vendor and device and thus need
>>> to be called super early.  On the other hand the code that adds quirks
>>> _reads_ the vendor and device.  It can't possibly move before
>>> init_card().  If folks are willing to take an additional host op of
>>> init_card_late() I can certainly go that way, though.
>>>
>>> The fourth patch is (I think) reviewed and ready to go assuming the
>>> other two land.
>>
>> I have queued this up for 3.20.
>
> Thanks!
>
>
>> It was a bit hard to follow the
>> updated the revisions, please don't send patches "in-reply-to" for
>> future sets.
>
> Very strange.  I didn't send out anything in-reply-to other than what
> git-send-email usually does.  I believe I had:
>
> [0] - no in reply to.
>  [1] - in reply to [0]
>  [2] - in reply to [0]
>  [3] - in reply to [0]
>  [4] - in reply to [0]

That's good. As long as there are no in-reply to previous versions of
patches/patchsets.

I am using gmails web-based client so it could very well be that it
does some magic, which I am not yet aware of.

>
> Is there some other way you'd prefer?
>
> Looking full headers in <https://patchwork.kernel.org/patch/5425241/>,
> I confirm it is "in-reply-to"
> "1417563767-32181-1-git-send-email-dianders@chromium.org".  Patchwork
> doesn't keep cover letters, but you can see at
> <http://www.spinics.net/lists/linux-mmc/msg29699.html>) that there is
> no in-reply-to.
>
> I'm more than happy to adjust my workflow if you can give me some
> specifics.  Thanks!  :)
>
>
>> In v5, I don't find a patch 1/4. Anyway, I have taken patch 2->4.
>
> Ah, maybe because it wasn't sent to linux-mmc?  I messed that up and
> will try to do better in the future.  Sorry.  :(  You were in the To
> line, though.  You can see at
> <https://patchwork.kernel.org/patch/5425241/>.
>
> Do you want me to repost it and CC linux-mmc with Tony's Ack?

I suggest you have a look at my next branch and to verify that I
haven't screwed things up. If so, either I should drop the patches and
you make a resend or if it's possible to just send an incremental path
on top?

Kind regards
Uffe

>
> ---
>
> Note: patchwork seems to find all my patches:
>
> pwclient list -w dianders@chromium.org -p ""
>
> 5425241 New          [v5,1/4] ARM: OMAP2+: Make sure
> pandora_wl1251_init_card() applies to SDIO only
> 5425291 New          [v5,1/4] ARM: OMAP2+: Make sure
> pandora_wl1251_init_card() applies to SDIO only
> 5425311 New          [v5,1/4] ARM: OMAP2+: Make sure
> pandora_wl1251_init_card() applies to SDIO only
> 5425231 New          [v5,2/4] mmc: core: Support the optional
> init_card() callback for MMC and SD
> 5425301 New          [v5,2/4] mmc: core: Support the optional
> init_card() callback for MMC and SD
> 5425271 New          [v5,3/4] mmc: dw_mmc: Cleanup disable of low
> power mode w/ SDIO interrupts
> 5425281 New          [v5,3/4] mmc: dw_mmc: Cleanup disable of low
> power mode w/ SDIO interrupts
> 5425251 New          [v5,4/4] mmc: dw_mmc: Protect read-modify-write
> of INTMASK with a lock
> 5425261 New          [v5,4/4] mmc: dw_mmc: Protect read-modify-write
> of INTMASK with a lock
