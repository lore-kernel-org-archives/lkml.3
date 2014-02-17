Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaBQQNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:13:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaBQQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:13:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>, keescook@chromium.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Date: Mon, 17 Feb 2014 17:13:07 +0100
Message-ID: <1418981.0py7JxXCp8@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140217155419.682F7C401D4@trevor.secretlab.ca>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> <201402121251.06280.arnd@arndb.de> <20140217155419.682F7C401D4@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/udp+ilRiH52N1xV3VJBmkDr2l9NXucRhSda/rDwTop
 Cmj3upQliL5NPgHyqG6RMl0j3IwnWajJzSFiY6+6jSOm1/tGkh
 hCVRZhDpJheWYBrB5ewvPbM6jKYWcXG/l+/BP7YRM8rBemoLXQ
 aajppa4OEbJ3l4czKnF+4Rdy0ds3Wg2yBNNHIP2B6mXhoptRZp
 Hdpb0Tdyk+Qrb9Yo2caDnNO2AyhptLZAjhYIOe7dRENHzCsROZ
 LwNurJ6GeJ6pZ93gXzc1sXa4LsXrjtk0ggZ2mzuI1sjEoIofoA
 4Sh/1gDZ8QB4KIXbjmtnONhnrl7t8WdMafKgX6/4zGPmrzv15T
 PJMzVaUk9HU0CxZzx60Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 February 2014 15:54:19 Grant Likely wrote:
> On Wed, 12 Feb 2014 11:20:00 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> > On Wed, Feb 12, 2014 at 12:45:54PM -0500, Jason Cooper wrote:
> > 
> > > The bootloader would then load this file into ram, and pass the
> > > address/size to the kernel either via dt, or commandline.  kaslr (run in
> > > the decompressor) would consume some of this randomness, and then
> > > random.c would consume the rest in a non-crediting initialization.
> > 
> > Sure is a neat idea, but I think in general it would probably be smart
> > to include the entire FDT blob in the early random pool, that way you
> > get MACs and other machine unique data too.
> 
> I applied a patch that did exactly that (109b623629), and then reverted
> it (b920ecc82) shortly thereafter because add_device_randomness() is
> a rather slow function and FDTs can get large. I'd like to see someone
> do a reasonable analysis on the cost of using an FDT for randomness
> before I reapply a patch doing something similar. An awful lot of the
> FDT data is not very random, but there are certainly portions of it that
> are appropriate for the random pool.

Could we use a faster hash function that scans the entire device tree and
then just feed the output of that into add_device_randomness? We probably
can't expect that there is a lot of entropy in the DT blob, so the
result wouldn't be all that different in terms of quality of the random
seed.

	Arnd
