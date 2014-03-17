Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbaCQQst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:48:49 -0400
Received: from verein.lst.de ([213.95.11.211]:57425 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbaCQQss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:48:48 -0400
Date: Mon, 17 Mar 2014 17:48:42 +0100
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
Subject: [PATCH 00/03]: khwrngd (Was: s390: provide hardware randomness
	from zcrypt card to /dev/random)
Message-ID: <20140317164842.GB1763@lst.de>
References: <alpine.LNX.2.00.1309121139000.3818@linux.site> <52322621.3040908@zytor.com> <alpine.LNX.2.00.1309191030180.3014@linux.site> <33dd164b-00a7-4cbd-9d62-66000ed4abbf@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33dd164b-00a7-4cbd-9d62-66000ed4abbf@email.android.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 08:05:32AM -0500, H. Peter Anvin wrote:
> As I said, the option of doing feed from hwrng directly
> via a kernel thread seems the most logical thing to me,
> assuming you can convince Ted & co.
> rngd doesn't really add much value for a whitened source.

Following up on this on (time flies!) I have moved the code
up into the arch-independent hw_random code and split it into 3
patches. First generate the injection point for true HWRNGs,
then create a thread that makes use of it and finally add
some simple on/off switch. The latter could be replaced with
something far more sophisticated if desired.

	Torsten

