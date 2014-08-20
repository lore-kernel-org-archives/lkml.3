Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaHTH6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:58:52 -0400
Received: from mout.gmx.net ([212.227.15.15]:50706 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaHTH6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:58:51 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, ds2horner@gmail.com
Subject: Re: [PATCH v2 3/4] zram: zram memory size limitation
Date: Wed, 20 Aug 2014 09:58:26 +0200
Message-ID: <2251457.nunIkSPjUl@fb07-iapwap2>
User-Agent: KMail/4.13.3 (Linux/3.17.0-rc1-12.gfc9498b-desktop; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140819233225.GA32620@bbox>
References: <1408434887-16387-1-git-send-email-minchan@kernel.org> <7959928.Exbvf4HrNB@fb07-iapwap2> <20140819233225.GA32620@bbox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart14239644.lTdfJoy1eL"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:PK27BdggJ7RE7rEg6bQmyqOm/mzwKjRSX0iVLr4VHz6jkq4j3xD
 bmgXi7mlOXRj+TJYDWxnpfg+sRSYDyjSSS775oZlzW33iEaiCRVXrXLTNpEP5Yz+6MRweiy
 3CJ5c0NCviwBFEcblqZ5Kis7PsyYIDnpFMDMXDTljzN5Q5ae4jPxgk/9BaHDRg6wkunS4a/
 DUlfh5E+fODIvtie06uNA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart14239644.lTdfJoy1eL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Am Mittwoch, 20. August 2014, 08:32:25 schrieb Minchan Kim:
> Hello,
> 
> On Tue, Aug 19, 2014 at 10:06:22AM +0200, Marc Dietrich wrote:
> > Am Dienstag, 19. August 2014, 16:54:46 schrieb Minchan Kim:
> > > Since zram has no control feature to limit memory usage,
> > > it makes hard to manage system memrory.
> > > 
> > > This patch adds new knob "mem_limit" via sysfs to set up the
> > > a limit so that zram could fail allocation once it reaches
> > > the limit.
> > 
> > Sorry to jump in late with a probably silly question, but I couldn't find
> > the answer easily. What's the difference between disksize and mem_limit?
> No need to say sorry.
> It was totally my fault because zram documentation sucks.
> 
> The disksize means the size point of view upper layer from block subsystem
> so filesystem based on zram or blockdevice itself(ie, zram0) seen by admin
> will have the disksize size but keep in mind that it's virtual size,
> not compressed. As you know already, zram is backed on volatile storage
> (ie, DRAM) with *compressed form*, not permanent storage.
> 
> The point of this patchset is that anybody cannot expect exact memory
> usage of zram in advance. Acutally, zram folks have estimated it by several
> experiment and assuming zram compression ratio(ex, 2:1 or 3:1) before
> releasing product. But thesedays, embedded platforms have varios workloads
> which cannot be expected when the product was released so compression
> ratio expectation could be wrong sometime so zram could consume lots of
> memory than expected once compression ratio is low.
> 
> It makes admin trouble to manage memeory on the product because there
> is no way to release memory zram is using so that one of the way is
> to limit memory usage of zram from the beginning.
> 
> > I assume the former is uncompressed size (virtual size) and the latter is
> > compressed size (real memory usage)? Maybe the difference should be made
> 
> Right.
> 
> > clearer in the documentation.
> 
> Okay.
> 
> > If disksize is the uncompressed size, why would we want to set this at
> > all?
> 
> For example, we have 500M disksize of zram0 because we assumed 2:1
> compression ratio so that we could guess zram will consume 250M physical
> memory in the end. But our guessing could be wrong so if real compression
> ratio is 4:1, we use up 125M phsyical memory to store 500M uncompressed
> pages. It's good but admin want to use up more memory for zram because we
> saved 100% than expected zram memory but we couldn't becuase upper layer
> point of view from zram, zram is already full by 500M and if zram is used
> for swap, we will encounter OOM. :(
> 
> So, it would be better to increase disksize to 1000M but in this case,
> if compression ratio becomes 4:1 by something(ex, workload change),
> zram can consume 500M physical memory, which is above we expected
> and admin don't want zram to use up system memory too much.
> 
> In summary, we couldn't control exact zram memory usage with only disksize
> by compression ratio.

thanks for your detailed explanation. It's a bit confusing that you can 
specify two limits (for two different layers). I guess a floating disksize is 
not possible, because you wouldn't be able to create a filesystem/swapfile on 
it, so you need to make a *fixed* assumption.

Regards,

Marc


--nextPart14239644.lTdfJoy1eL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJT9FUjAAoJEKyeR39HFBtoMD8H/RmlKtaBlhTrVSn/W/M9V+/B
Auzj6t21Y4qQ3zdo0q9i2PS8JLoqU6rW6Znfdv43I8bNAci49WtuCM6NWKgmicSs
JhvxPlG4ixdf836vD2D/q4LfQ/4pJowAMc8B/WwjAgV5dnPwosRjGOAlAkhBpnhI
6N9pXw/84+m4eew6Qazz2OnLN4BtyYErvrps33xbWtkCXa/diq4u9VzXDOWtfbl7
8GoBNsg/yS9YLo6HA7DTdl9HwCv8OENeHoB5XLBy+XeVa1TKUFmFh3MyIwPjHGb1
Sz66NSPaOPGiR05iEmaK8x6L6k/0RKOCcsJnpDrC2QNVvOvf8noHchiKB2LDNFM=
=HOsN
-----END PGP SIGNATURE-----

--nextPart14239644.lTdfJoy1eL--

