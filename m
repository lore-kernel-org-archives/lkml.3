Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3IJVkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:40:02 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33636 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3IJVkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:40:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com>
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
	<CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
	<CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com>
Date: Tue, 10 Sep 2013 14:39:59 -0700
Message-ID: <CA+bK7J4F=X97HUQP6Tt8RkVe5vttE_Sw4Pd7kT19k_KGDFfpKA@mail.gmail.com>
Subject: Re: [GIT PULL] Device tree updates for v3.12
From: Tim Bird <tbird20d@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        anton@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 1:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Sep 10, 2013 at 11:40 AM, Tim Bird <tbird20d@gmail.com> wrote:
>> How much time does it add to boot to feed the device tree into the
>> random number pool.
>>
>> Some of the device trees are expected to get pretty big.  If it's over
>> a millisecond, IMHO, it should be configurable (but this is not).
>
> It's detinitely not a very fast operation.
...
> So it might even be a better idea to feed the device tree to a hashing
> function (eg SHA1 or even just MD5), and then just mix in the hash. At
> least most block hash functions do things a word at a time. It does
> *not* need to be cryptographically secure, so MD5 would be plenty good
> enough - the only point of the hash would be to give a meaningful
> number of result bits from the source array.

Well, I'm not sure how many bits of randomness this will add anyway.
The way we're using device tree, we get the same values every boot, on
all instances of the same phone model.  So this seems of little value.

Anton,

Are there presumably some random fields in device tree?  Is this being used
to pass randomness from the bootloader?  Or are you trying to mix in some
"randomness" about the hardware configuration?  I'm trying to understand the
rationale for this.

 -- Tim Bird
Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
