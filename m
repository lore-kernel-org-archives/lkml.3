Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3CLWNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:13:53 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:36469 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3CLWNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:13:51 -0400
MIME-Version: 1.0
Date: Tue, 12 Mar 2013 23:13:50 +0100
X-Google-Sender-Auth: VrIFGqaoEASxpX1JM-JzkPdIs7M
Message-ID: <CAMuHMdXyBqwqn3aWpjwer5HYYqQvyMJTxJY-WeDGxLxkg_ZXQw@mail.gmail.com>
Subject: [-next] staging/comedi regressions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdevel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/allmodconfig:

drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_isapnp_find_board’:
drivers/staging/comedi/drivers/ni_atmio.c:353: error: ‘n_ni_boards’
undeclared (first use in this function)
drivers/staging/comedi/drivers/ni_atmio.c:353: error: (Each undeclared
identifier is reported only once
drivers/staging/comedi/drivers/ni_atmio.c:353: error: for each
function it appears in.)
drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_getboardtype’:
drivers/staging/comedi/drivers/ni_atmio.c:391: error: ‘n_ni_boards’
undeclared (first use in this function)
drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_atmio_attach’:
drivers/staging/comedi/drivers/ni_atmio.c:470: error: ‘boardtype’
undeclared (first use in this function)

http://kisskb.ellerman.id.au/kisskb/buildresult/8392062/

Seems like the following two commits removed some macros:

commit 6293e35742550320b1720044f9969d9544a5deaa
Author: H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Tue Mar 5 10:20:41 2013 -0700

    staging: comedi: ni_stc.h: remove boardtype macro

ayla$ git show f5a1d92bf6f4fa063d5ea43613f43494896e333f
commit f5a1d92bf6f4fa063d5ea43613f43494896e333f
Author: H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Tue Mar 5 10:21:03 2013 -0700

    staging: comedi: ni_stc.h: remove n_ni_boards macro

while they're still used by drivers/staging/comedi/drivers/ni_atmio.c.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
