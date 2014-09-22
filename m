Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaIVKNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:13:04 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:59150 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaIVKND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140922083929.GG1470@ulmo>
References: <1409626606-15225-1-git-send-email-djkurtz@chromium.org> <20140922083929.GG1470@ulmo>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 22 Sep 2014 18:12:41 +0800
X-Google-Sender-Auth: zNLq-bCFnzJuae0c2hyUWq_8_XA
Message-ID: <CAGS+omBFQi2BokDCV8DpRYwKs7DsGWKfxtDu8+7zJfKatL0SeA@mail.gmail.com>
Subject: Re: [PATCH] drm/panel: update innolux n116bge timings
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 4:39 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
>
> On Tue, Sep 02, 2014 at 10:56:46AM +0800, Daniel Kurtz wrote:
> > There are several different models of N116BGE.  According to the commit
> > that added innolux_n116bge_mode [0], this N116BGE is for the eDP variety.
> >
> > [0] commit 0a2288c06aab73c966e82045c8f20b0e713baf2a
> >  Author: Thierry Reding <treding@nvidia.com>
> >  Date:   Thu Jul 3 14:02:59 2014 +0200
> >
> >    drm/panel: simple: Add Innolux N116BGE panel support
> >
> > The clock and htotal values from add by that patch are out of spec according to
> > the datasheets I have seen for the eDP N116BGE (-EA2 and -EB2).
>
> Does out of spec imply that these timings aren't working for you?

No, I didn't even try with your values, actually.
Out of spec just means that the numbers do not fall between Min and
Max on the datasheet:

72.6 <= DCLK <= 80.24 vs. 71
1506 <= htotal <= 1716 vs. 1500

> > This patch changes the values to the "Typ" values on the datasheet.
>
> The original patch was based on -E42 of the datasheet. But I can run
> some tests to see if the timings in this patch work on the panel that I
> have. If so I guess the easiest would be to apply this.

Thanks!

>
> It shouldn't matter all that much since the panel has EDID if I remember
> correctly. The modes parsed from EDID should take precedence over the
> fixed mode. If they don't then that's a bug.

The driver I am testing this with does not yet support reading the
EDID over eDP, so I am using the fixed values for now.

> Thierry
>
