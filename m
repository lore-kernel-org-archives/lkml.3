Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaDNQoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:44:14 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:53863 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaDNQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140414162451.GE29351@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de>
 <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
 <20140414160211.GE711@lst.de> <7b22b881-9359-42c9-a632-6a8cbdb13b71@email.android.com>
 <20140414162451.GE29351@lst.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Apr 2014 09:43:51 -0700
Message-ID: <CALCETrX1oSEYxbTU-_zP+G_PgkZKa1cw-t4-5PLngw1uusYAig@mail.gmail.com>
Subject: Re: [PATCH v3 00/03]: hwrng: an in-kernel rngd
To: Torsten Duwe <duwe@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 9:24 AM, Torsten Duwe <duwe@lst.de> wrote:
> On Mon, Apr 14, 2014 at 09:09:14AM -0700, H. Peter Anvin wrote:
>> I think the default should be zero, so each hwrng driver maintainer would have to consider what guarantees that particular driver can give.  If anything 50% ought to be the maximum.
>
> Repost of v4 just for patch 03/03 is on its way then, defaulting to 0
> (off), which happens to be the old behaviour, which I think I've also
> expressed my sympathy for already.
>

To be clear, I like your patches, bikeshedding aside.  Having reads of
/dev/random automatically pull in hwrng data would be *great*.  My
drbg patches are not meant to replace them at all.  I just think that
there's a need for the nonblocking pool to be well-seeded as quickly
as possible, regardless of configuration, and I don't think your code
is meant to do that.

--Andy
