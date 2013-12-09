Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab3LIQMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:12:06 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41379 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933816Ab3LIQMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:12:02 -0500
MIME-Version: 1.0
In-Reply-To: <1922780.plAOmhqzpW@amdc1227>
References: <1384971686-7208-1-git-send-email-djkurtz@chromium.org> <1922780.plAOmhqzpW@amdc1227>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 10 Dec 2013 00:11:40 +0800
X-Google-Sender-Auth: dnEASEJGQ1uuLkpupWXGFTcgHkE
Message-ID: <CAGS+omDq95paoHsf5-i2gbRoSGvqn36zNO93KHGi2FGhfGMsrw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: EXYNOS: pmu: Constify data tables
To: Tomasz Figa <t.figa@samsung.com>
Cc: kgene.kim@samsung.com, Heiko Stuebner <heiko@sntech.de>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Doug Andersen <dianders@chromium.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Thank you for the reviews.

On Dec 9, 2013 5:15 AM, "Tomasz Figa" <t.figa@samsung.com> wrote:
>
> Hi Daniel,
>
> On Thursday 21 of November 2013 02:21:24 Daniel Kurtz wrote:
> > These tables are all immutable, make them const to save 4416 bytes of RAM.
> >
> > size arch/arm/mach-exynos/pmu.o
> >    text          data     bss
> >     848          4420       4         // before
> >    5264             4       4         // after
>
> I'm not sure where the mentioned saving of RAM is. Moving data between
> sections is not supposed to make it use less memory, I believe.

You are correct.  This was my misunderstanding from doing too much
work with microcontrollers, where .text sections are accessed in place
from FLASH for code and const data, but .data memory is copied from a
FLASH section to a second RAM section at init for access at runtime.
Most modern Linux systems copy/decompress their code and data sections
from external storage to RAM anyway, so there is no actual memory
savings (except potentially the compiler may be able to optimize a bit
more with the const hint).

>
> Anyway, it's a good practice to mark constant data as const, to disallow
> changing them at runtime by mistake, so the patch is fine. Except some
> issues I commented on inline.

Were there supposed to be inline comments?  I don't see any.

Best Regards,
-djk

>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>
> Best regards,
> Tomasz
>
