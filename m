Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3EHE1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:27:37 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:47062 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3EHE1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:27:35 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:d10f:766e:8222:5d5a]
In-Reply-To: <CA+55aFxsQSrRxGDjvFW84ezYj4PZPX=hSpsyNG-AqewbJ7X4Bw@mail.gmail.com>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
	<1367947574-2934383-5-git-send-email-arnd@arndb.de>
	<20130507231925.GR28721@atomide.com>
	<CA+55aFxHZSYV3UZMf+ezADX5z2psLm5a9Wpp6qcDQho7n2J6SA@mail.gmail.com>
	<20130508031758.GT28721@atomide.com>
	<CA+55aFxsQSrRxGDjvFW84ezYj4PZPX=hSpsyNG-AqewbJ7X4Bw@mail.gmail.com>
Date: Tue, 7 May 2013 21:27:34 -0700
Message-ID: <CAOesGMiWoB_4DrgUyMUx5MzO9dwMKBm=ZzVHosWUoC_+OpV_Zw@mail.gmail.com>
Subject: Re: [GIT PULL 4/5] ARM: arm-soc: late cleanups
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>, ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 8:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> The ARM history has gotten much much better, but it's full of these
> kinds of incestuous merges. The pull requests I get are not truly
> independent development, although especially the early pull requests
> are much less tightly coupled than they used to be.

A lot of this comes from the way we structure the submaintainers
submissions to arm-soc: Cleanups on the bottom, then new SoC support,
then board and dt changes, etc. It means there are a lot of branches
that build on top of each other. It's not uncommon that a
submaintainer needs to build some new feature on top of both some
cleanup as well as some other new development, which is then what
causes some of these merges and backmerges.

While our splitting into categories (cleanup/soc/board/dt/drivers)
isn't 100% natural for each submaintainer, it does allow us to force
some thought into how it all fits together between vendors, and it
also allows us to split the code up into sets that make a bit more
sense (IMHO) when it's sent up to you.

Our lives (short-term) would be a lot easier if we just did one long
single branch and we sent that up, with mostly serial history. But I
also think it's been working reasonably well to expose a bit more
w.r.t. who's spending efforts on cleanup and refactoring old code
code, and who's pumping in new features and drivers.

I'm definitely open for suggestions on how to improve the way we do things.


-Olof
