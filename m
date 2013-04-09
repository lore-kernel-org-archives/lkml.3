Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936716Ab3DIBvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:51:13 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42211 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3DIBvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130409003720.GA5145@thunk.org>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAJ-VmomS_=1=QLZrfdD4vhu9Qy0w2JNQxEFrkt_OKjWetrWY4w@mail.gmail.com>
	<CAFSJ42b7DD9UVtzT7YWhaEchzwpde0yW=pS3nJVeMCHoVQGBqQ@mail.gmail.com>
	<201304090003.47056.chunkeey@googlemail.com>
	<CAJ-VmomksDSNvTpKQpNRRQx+QboSVHpby7V4qq4rngqVkTvf+A@mail.gmail.com>
	<20130409003720.GA5145@thunk.org>
Date: Mon, 8 Apr 2013 18:51:10 -0700
X-Google-Sender-Auth: V9DCJRhAQFt_cmkOlSnrFICkmlk
Message-ID: <CAJ-VmokQ=1FLnn-0Ew1JTY_WhYuSYmZq2=DuNTV0TR3kF4wo7g@mail.gmail.com>
Subject: Re: Version number policy!
From: Adrian Chadd <adrian@freebsd.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Adrian Chadd <adrian@freebsd.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>, Kalle Valo <kvalo@adurom.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2013 17:37, Theodore Ts'o <tytso@mit.edu> wrote:

> There shouldn't be any crap; just a an error message indicating that
> "the file system has features which this implementation doesn't
> understand".  At least, if the implementation was competently
> coded.... (ext2/3/4 has feature bitmasks that make it very clear what
> features are required so that an implementation can mount the file
> system read/write or read/only).

Right, the design side of it is fine.

But then you end up with people making filesystems which aren't
necessarily backwards compatible (and aren't aware of this), then try
to share with other extX implementations; or boot an older Linux
kernel (eg plugging an ext3 device on a newer box to an older box.)
Now, ext3 is a bit more mature nowdays so people aren't _always_
hitting this corner case. But I do recall earlier on when things were
moving forward quite quickly, people would create drives on Linux
machine X that couldn't be read or written to on Linux machine Y.

I'm not knocking extX here; I'm just pointing out that exposing things
as a set of capability flags doesn't magically fix interoperability.
It just stops you from scribbling crap where it shouldn't be.



Adrian
