Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaIZMaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:30:55 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58236 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbaIZMax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:30:53 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
Date: Fri, 26 Sep 2014 14:30:53 +0200
Message-ID: <CACRpkdZoo=P7uTO1rNDD_HUPjfAk26C0=mNYPoZmTV0wcO3V-w@mail.gmail.com>
Subject: Re: [git pull] Devicetree changes for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 12:15 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> Here are the dt changes I've got queued up for v3.15. The full
> description is below in the tag. Please pull.
(...)
> Jason Cooper (1):
>       kbuild: dtbs_install: new make target

After this patch a while back I have observed the following behaviour
of the kernel build:

make zImage
make zImage
-> incremental build, just relink

make zImage
make dtbs
make zImage
-> The whole kernel gets rebuilt

So now if I happen to recompile my device trees, I suddenly want
the entire zImage to be rebuilt to? It's by definition not changes that
affect the kernel build :-(

I noticed this because my build scripts calls make dtbs && make zImage,
and started to rebuild absolutely everything all the time.

Do you think this can be fixed? It's quite simple to reproduce...

Yours,
Linus Walleij
