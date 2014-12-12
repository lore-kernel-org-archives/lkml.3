Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaLLXyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:54:18 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55335 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaLLXyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:54:16 -0500
MIME-Version: 1.0
In-Reply-To: <8867707.LK6gZlxufx@phil>
References: <8867707.LK6gZlxufx@phil>
Date: Fri, 12 Dec 2014 15:54:15 -0800
X-Google-Sender-Auth: cKjq1wrWDFeUW3EzCJ--RjhXv50
Message-ID: <CAD=FV=VfnXHpZiTMh8+WHyEQ=N0cVNrDLLjmU+xC1ne-uYbuEQ@mail.gmail.com>
Subject: Re: regression on rk3288 with - mmc: dw_mmc: Remove old card detect infrastructure
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 12, 2014 at 12:22 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Hi,
>
> when trying linux-next for 20141210 on my rk3288 eval board I got errors
> when ejecting sd cards. Especially a timeout for a command and following
> this an rcu stall which essentially stops everything [0].
>
> My way to reproduce the issue is:
> - boot into an initramfs
> - insert card
> - remove card
> - boom
>
> It happens 100% of the time on the first removal of the card.
>
>
> Bisecting the issue brought me to
>
> first bad commit
> 6130e7a9c34d01afbd4e7e215846d1f2d70333bb
> mmc: dw_mmc: Remove old card detect infrastructure
>
> and indeed if I revert this one, card ejection works again - also multiple
> times in a row. Affected machine is a rk3288-evb-rk808 board which
> currently uses the internal card-detect mechanism of the dw_mmc and
> relevant git history (--oneline) is:
>
> 864de9b Revert "mmc: dw_mmc: Remove old card detect infrastructure"
> 5bd48e0 ARM: dts: Bump SD card pin drive strength up on rk3288-evb
> 12fd072 Add linux-next specific files for 20141210
> ...
>
>
> I'll try to dig deeper, but if anybody has ideas beforehand I would also
> be very glad.

I tried to reproduce this on the same board on 20141211.  I have a
different bootloader, but I hope that doesn't matter?

git describe
next-20141211-1-gf8afbb8

$ git log --oneline next-20141211~..
f8afbb8 FROMLIST: ARM: dts: Bump SD card pin drive strength up on rk3288-evb
291ca61 Add linux-next specific files for 20141211


In inserted 3 different cards into the SD card slots (a micro UHS, an
older micro one, and a full sized UHS).  I inserted / ejected each one
several times.

Could it be a different set of kernel config options?  That's about
the best guess I can come up with...
