Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbaCUO36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:29:58 -0400
Received: from verein.lst.de ([213.95.11.211]:40325 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbaCUO3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:29:55 -0400
Date: Fri, 21 Mar 2014 15:29:50 +0100
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>, duwe@lst.de
Subject: [PATCH v2 00/03]: khwrngd
Message-ID: <20140321142950.GI1763@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is version 2 of the khwrngd patch set.

The first patch is unchanged.

The second one now introduces an initial derating factor,
as suggested by hpa. It's called derating_current to simplify
patch#3, and the thread creation has moved into hwrng_init,
because it may later depend on the hwrng's derating property.

The third patch only introduces the derating member to
struct hwrng and provides a configurable default.

I could imagine to further add a derating_extra parameter
for conservative admins, in order to diminish the entropy
estimation given from the driver author even more. OTOH
too many knobs might cause confusion.

	Torsten

