Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaB1Sol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:44:41 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48308 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaB1Soj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:44:39 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH] ARM: qcom: Enable basic support for Qualcomm platforms in multi_v7_defconfig
References: <1393360445-16923-1-git-send-email-galak@codeaurora.org>
	<7hy50xv3rw.fsf@paris.lan> <7hzjlbtc9y.fsf@paris.lan>
	<20140228182745.GC2487@codeaurora.org>
Date: Fri, 28 Feb 2014 10:44:36 -0800
In-Reply-To: <20140228182745.GC2487@codeaurora.org> (Stephen Boyd's message of
	"Fri, 28 Feb 2014 10:27:45 -0800")
Message-ID: <7heh2nt6uj.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> On 02/28, Kevin Hilman wrote:
>> Hi Kumar,
>> 
>> Kevin Hilman <khilman@linaro.org> writes:
>> 
>> > Kumar Gala <galak@codeaurora.org> writes:
>> >
>> >> Enable support for the MSM8x60, MSM8960, and MSM8974 SoCs, clocks and
>> >> serial console as part of the standard multi_v7_defconfig.
>> >>
>> >> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> >> ---
>> >>
>> >> I leave this to the arm-soc guys to apply because of possible conflicts
>> >> with other updates to multi_v7_defconfig.
>> >
>> > Seem to be a handful of !qcom changes here, probably resulting from a
>> > run of 'make savedefconfig' without all the new changes in.
>> >
>> > I've thinned this out to only the qcom changes and applied the following
>> > to next/boards.  I think it's better to do any 'make savedefconfig'
>> > cleanups as a separate, cleanup-only patch as needed.
>> 
>> Bisecting a new boot failure on u8500/snowball came down to this patch.
>> Simply disabling CONFIG_ARCH_QCOM in mutli_v7_defconfig gets the
>> u8500/snowball booting again, so it looks like there may still be some
>> qcom specifics that are being run on non-qcom platforms with a
>> multi-platform config.
>> 
>> Could you audit for initcalls/drivers being initialized on non-qcom
>> SoCs?
>> 
>
> Can you try disabling CONFIG_ARCH_MSM8X60 and
> CONFIG_ARCH_MSM8960? MY suspicion is the text offset movement is
> causing problems, but I hope I'm wrong.

Sorry to dash your hopes, but you're right.

Starting from a fresh multi_v7_defconfig and disabling those two Kconfig
options gets the snowball booting again on multi_v7_defconfig.

Kevin

