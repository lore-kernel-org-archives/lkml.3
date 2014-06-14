Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaFNXgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 19:36:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34762 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaFNXgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 19:36:41 -0400
Message-ID: <539CDC6F.6010501@zytor.com>
Date: Sat, 14 Jun 2014 16:36:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Rich Felker <dalias@libc.org>
CC: Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>,
        Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
References: <cover.1402769596.git.luto@amacapital.net> <20140614213000.GO179@brightrain.aerifal.cx> <CALCETrX3Kv7VAfYau-79odKtRvME0-AzZB_xGUMPEHeas8AkaQ@mail.gmail.com>
In-Reply-To: <CALCETrX3Kv7VAfYau-79odKtRvME0-AzZB_xGUMPEHeas8AkaQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2014 03:38 PM, Andy Lutomirski wrote:
> 
> Hmm.  I hadn't thought of this as a size win, but I guess it could be
> if there are static binaries around.
> 

That pretty much *is* the win, because this is in effect treating the
kernel vdso as a shared library.

> This patch currently generates 488 bytes on text with my toolchain.
> More than half of that is garbage needed to deal with the symbol
> version tables, and I should be able to move a decent fraction of it
> to vdso2c and therefore out of the kernel and vdso images.

Now, if we can do this without adding another page then that becomes
much more compelling IMO.  I suspect we can if you are already down to
488 bytes.

	-hpa


