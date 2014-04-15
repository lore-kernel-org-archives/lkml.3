Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaDOQyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:54:17 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:44706 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDOQyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140415085126.GA17327@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de>
 <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
 <20140414160211.GE711@lst.de> <20140414160653.GC29351@lst.de>
 <CALCETrUmFdrGExKB+tKSMVK1yWAw6KWU1tpgjnoFe=+XhJdtTw@mail.gmail.com> <20140415085126.GA17327@lst.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Apr 2014 09:53:53 -0700
Message-ID: <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com>
Subject: Re: [PATCH v3 03/03]: hwrng: khwrngd derating per device
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

On Tue, Apr 15, 2014 at 1:51 AM, Torsten Duwe <duwe@lst.de> wrote:
> On Mon, Apr 14, 2014 at 09:41:10AM -0700, Andy Lutomirski wrote:
>> On Mon, Apr 14, 2014 at 9:06 AM, Torsten Duwe <duwe@lst.de> wrote:
>> >
>> > This patch introduces a derating factor to struct hwrng for
>> > the random bits going into the kernel input pool, and a common
>> > default derating for drivers which do not specify one.
>> >
>> > Signed-off-by: Torsten Duwe <duwe@suse.de>
>> >
>> > ---
>> >  drivers/char/hw_random/core.c |   11 ++++++++++-
>> >  include/linux/hw_random.h     |    3 +++
>> >  2 files changed, 13 insertions(+), 1 deletion(-)
>> >
>> > --- linux/include/linux/hw_random.h.orig
>> > +++ linux/include/linux/hw_random.h
>> > @@ -29,6 +29,8 @@
>> >   * @read:              New API. drivers can fill up to max bytes of data
>> >   *                     into the buffer. The buffer is aligned for any type.
>> >   * @priv:              Private data, for use by the RNG driver.
>> > + * @derating:          Estimation of true entropy in RNG's bitstream
>> > + *                     (per mill).
>>
>> I'll bikeshed again: this is a rating, not a *de*rating.  Higher =
>> more confidence, at least assuming the comment is right.
>>
> You're right. Would anyone object to call it "quality", as in RX signal quality?
> In context of a random source that is pretty accurate, I'd say. Other opinions?

I'm okay with "quality", although I'm still partial to "entropy_per_1000bits".

--Andy
