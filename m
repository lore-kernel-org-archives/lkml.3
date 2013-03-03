Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3CCPja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 10:39:30 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62877 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3CCPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 10:39:28 -0500
MIME-Version: 1.0
In-Reply-To: <1362303621.13011.14.camel@mattotaupa>
References: <1362289927-3635-1-git-send-email-mc74hc00@gmail.com>
	<1362303621.13011.14.camel@mattotaupa>
Date: Mon, 4 Mar 2013 00:39:26 +0900
Message-ID: <CAHh0gOinjQvHV4yG+w4Lu+ZJ9ZWS=EgnDjCrFHAwkfquWEPhCg@mail.gmail.com>
Subject: Re: [PATCH v2] sp5100_tco: Remove code that may cause a boot failure
From: Tanaka Takahisa <mc74hc00@gmail.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thank you for your advice!
The patch reflecting what was pointed out is posted later.

2013/3/3 Paul Menzel <paulepanter@users.sourceforge.net>:
> I still do not understand it, as your patches were for SB8x0 support,
> right?

There are two methods of accessing the watchdog registers.

 1. Re-programming a resource address obtained by allocate_resource()
to chipset.
 2. Use the direct memory-mapped IO access.

The method 1 can be used by all the chipsets (SP5100, SB7x0, SB8x0 or
later). However, experience shows that only PC with the SB8x0 (or
later) chipsets can use the method 2.

This patch removes the method 1, because the critical problem was found.
That's why the watchdog timer was able to be used on SP5100 and SB7x0
chipsets until now.


> Is this patch exactly reverting these two patches?

Yes. This patch was made on the linux-next brunch (next-20130301).

This patch is dependent on the following patches. So, This patch isn't
applicable to Linux 3.8 kernel which doesn't apply the following patches.

  commit adbdcc030be5f7bb54d229c04efdd0c6b7ed3ab7
      watchdog: sp5100_tco: Write back the original value to reserved
bits, instead of zero

  commit a6e26b1369b34760ca5e1f16039c9018bf68ce7e
      watchdog: sp5100_tco: Fix wrong indirect I/O access for getting
value of reserved bits


> As Linux 3.8 has been released, please add

The above-mentioned two patches may be soon applied to stable kernel (3.8.n).

https://lkml.org/lkml/2013/3/1/546

I thought that I should submit this patch to the stable after these
two patches are merged into stable 3.8.n.


Regards,
Takahisa
