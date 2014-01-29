Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaA2Cod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:44:33 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:49677 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaA2Coc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:44:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140127214338.4167.57312@quantum>
References: <20140127214338.4167.57312@quantum>
Date: Tue, 28 Jan 2014 18:44:31 -0800
X-Google-Sender-Auth: PTveKDhjqr8lXsAPb0nWHVio-ZM
Message-ID: <CA+55aFyXFJO_sMD+74F1sSmbxO-tKXGr-vetKYacUeLODBv-pw@mail.gmail.com>
Subject: Re: [GIT PULL] clk: changes for 3.14, part 2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 1:43 PM, Mike Turquette <mturquette@linaro.org> wrote:
>
>   git://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.14-part2

Dammit, this is pure shit, and after having to deal with yet another
pointless merge conflict due to stupid "cleanups" in Makefiles, IT
DOES NOT EVEN COMPILE.

drivers/clk/clk-si5351.c: In function ‘si5351_i2c_probe’:
drivers/clk/clk-si5351.c:1314:2: error: too many arguments to function
‘si5351_dt_parse’
  ret = si5351_dt_parse(client, variant);
  ^
drivers/clk/clk-si5351.c:1296:12: note: declared here
 static int si5351_dt_parse(struct i2c_client *client)

And no, that's not due to a merge error of mine. It was that way in your tree.

Hulk angry. Hulk smash.

I fixed it up in the merge, but I shouldn't need to. This should have
been caught in -next, and even if you compile for ARM as your primary
target, I know *damn* well that no sane ARM developer actually
compiles *on* ARM (because there are no machines where it's worth the
pain), so you should make sure that the x86-64 build works too.

If I can find compile errors within a couple of minutes of pulling and
it's not a merge error of mine, the tree I'm pulling from is clearly
crap.

So I'm more than a bit grumpy. Get your act together, and don't send
me any more shit.

In fact, I would suggest you send nothing but obvious fixes from now
on in this release. Because I won't be taking anything else.

              Linus
