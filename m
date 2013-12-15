Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3LORDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:03:03 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:53777 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3LORDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:03:02 -0500
MIME-Version: 1.0
In-Reply-To: <20131215130636.GA12686@S2101-09.ap.freescale.net>
References: <1385416655-7859-1-git-send-email-festevam@gmail.com>
	<20131126004603.GU14725@sirena.org.uk>
	<20131127005520.GS14725@sirena.org.uk>
	<20131215130636.GA12686@S2101-09.ap.freescale.net>
Date: Sun, 15 Dec 2013 15:03:00 -0200
Message-ID: <CAOMZO5DHYgJY4dpB+znx9g3TChUNn3ujdtCf0OsmkbGtrE9R1A@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Use postcore_initcall(regulator_init_complete)
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 11:06 AM, Shawn Guo <shawn.guo@linaro.org> wrote:

> What is going on about that patch?

Mark fixed the problem with the following commits:

commit 75bc9641cadd2a3f91f9c2e7f2fdfdeb8bd4b1d6
Author: Mark Brown <broonie@linaro.org>
Date:   Wed Nov 27 16:22:53 2013 +0000

    regulator: core: Check for DT every time we check full constraints

    Eliminate the gap between DT becoming available and this being used to say
    we have full constraints by checking directly for DT every time we check
    for full constraints. This improves interoperaton with optional regulator
    support.

    Signed-off-by: Mark Brown <broonie@linaro.org>
    Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

commit 87b2841753e1694fc96fefb467f6aff9940b07af
Author: Mark Brown <broonie@linaro.org>
Date:   Wed Nov 27 16:13:10 2013 +0000

    regulator: core: Replace checks of have_full_constraints with a function

    Simple code reorganisation so we can change the logic for deciding what
    full constraints are more easily.

    Signed-off-by: Mark Brown <broonie@linaro.org>

Regards,

Fabio Estevam
