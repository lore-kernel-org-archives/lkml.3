Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3CDBsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:48:30 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:45004 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3CDBs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:48:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6s=TW1W+S4715sf+N+t+dKjTVBk+mRVYC_74rRC0r4QvA@mail.gmail.com>
References: <CACxGe6sweLxtsW9OYb8m7esYguGmStEsuZc0tOgZN6H5Zfy1+g@mail.gmail.com>
 <CA+55aFxzN7=z7_iVQ=JvYms1WaCoX-hQ2jKNqLU2dLy63AYK1g@mail.gmail.com> <CACxGe6s=TW1W+S4715sf+N+t+dKjTVBk+mRVYC_74rRC0r4QvA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 4 Mar 2013 09:48:09 +0800
X-Google-Sender-Auth: 3tkMWhL2v6MbeVrJt4V9dsbOMnc
Message-ID: <CACxGe6u-7PxSzNovNZ5ujsOjWgMGTje1aOtkRuXoJkDB7uEqbg@mail.gmail.com>
Subject: Re: [GIT PULL] gpio changes for v3.9; second round
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 5:32 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Mar 4, 2013 at 2:50 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Should this driver depend on CONFIG_OF_GPIO, or should it have
>> #ifdef's? Regardless, it's clearly broken right now.
>>
>> Unpulled.
>
> Ugh. Well I clearly screwed that up. Sorry. I'll fix that right away.

Okay, I've dropped the top two commits from that tag. The broken
commit and the one above it were certainly not critical. They can wait
until v3.10. Here's a new pull request.

g.

The following changes since commit b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50:

  Merge tag 'lzo-update-signature-20130226' of
git://github.com/markus-oberhumer/linux (2013-02-28 20:45:52 -0800)

are available in the git repository at:


  git://git.secretlab.ca/git/linux tags/gpio-for-linus

for you to fetch changes up to e97f9b5277afeabb54892ebc6f68500098467ba1:

  gpio/gpio-ich: fix ichx_gpio_check_available() return what callers
expect (2013-03-02 13:20:21 +0000)

----------------------------------------------------------------
2nd round of GPIO changes for Linux 3.9

This branch contains a few bug fixes that I missed the first time around
and updates to the gpio_desc series included in the first pull request.
This tag has been retagged to drop the 2 head commits because the one of
them caused a build failure.

----------------------------------------------------------------
Alexandre Courbot (3):
      gpiolib: check descriptors validity before use
      gpiolib: use const parameters when possible
      gpiolib: move comment to right function

Mika Westerberg (1):
      gpio/gpio-ich: fix ichx_gpio_check_available() return what callers expect

 drivers/gpio/gpio-ich.c |    4 +-
 drivers/gpio/gpiolib.c  |  143 +++++++++++++++++++++++++++--------------------
 2 files changed, 84 insertions(+), 63 deletions(-)
