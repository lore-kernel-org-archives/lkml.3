Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaFAXBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 19:01:51 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:34636
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFAXBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 19:01:49 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=FZq5xfO6 c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=_LNj2pMP9rQA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=YRTPxWTwSe1K2sfPLp8A:9
 a=aEs1wHJ5MpNIBc6f:21 a=6umvBD7X8iIOkED9:21 a=QEXdDO2ut3YA:10
Date: Mon, 2 Jun 2014 00:01:46 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org, robbat2@gentoo.org
Subject: Re: Licensing & copyright of kernel .config files (defconfig,
 *config)
Message-ID: <20140601230146.GB31939@milliways>
References: <robbat2-20140601T012929-356267352Z@orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <robbat2-20140601T012929-356267352Z@orbis-terrarum.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 01:43:01AM +0000, Robin H. Johnson wrote:
> (Please CC me on replies, not subscribed to LKML)
> 
> Hi,
> 
> Somewhat of an odd question, but none of the files in question seem to
> have a copyright header on them...
> 
> For a kernel .config file, either from one of the defconfig or any other
> *config option that automates the answer:
> 1. What license does the file fall under?
> 2. Who are the copyright holders?
> 
> Naively, since the defconfigs are bundled with the kernel, that could
> fall under GPLv2-only implicitly, but lacking any explicit copyright
> headers makes this interesting (arch/*/configs/* contain lots of files,
> no copyright headers on them).
> 

 I am not a lawyer, but surely _many_ of the kernel files do not
contain any explicit copyright information ?

> If I manually write the names of some configuration options to a new
> .config file, at that point I logically am the only author and have
> copyright of it. My editor slaps a default license on it of BSD-2.
> Thereafter I run olddefconfig, and now it's a combined work of the
> kernel's defconfig and my manual settings. If GPL-2 was inherited from
> the kernel tree, this is now a combined BSD-GPL2 work, or is it? The
> kernel config tools did consider my file as input, possibly overrode the
> settings if they didn't work with others, and re-output everything.
> 

 Why does your editor put a default license on anything ?  In some
cases, it is bound to be wrong.  For example, if you were to ever
submit a kernel patch, in the kernel the license would be GPL-2
although, if you created a new file, you could also license that as
BSD-2 if it was not a derivative of existing kernel code.
Similarly, if you ever create a patch for any other project which
does not use a BSD license, then your patch will have uncertain
status.

 If I was being awkward, I would suggest that the config would not
be useful until you had run it through "make oldconfig" or similar,
and that therefore the kernel license of GPL-2 applies.

> If the files are to be marked with a copyright header, who is the holder
> of it that it should be attributed to?
> 

 Iff the work is copyrightable (I do not have an opinion on that),
surely the license only matters if you breach it ? ;-)  If you
distribute a compiled kernel with the source, and all of that source
is GPL-2, then I assume you are in the clear.  For "extras" which
include binaries without source, my understanding is that you would
always be vulnerable to kernel copyright holders.  So, I suspect
that the attribution of a config file is not particularly important.

> Alternatively, is this a case where the work is not copyrightable, and
> the files should have a notice to that effect?
> 
> Background:
> Gentoo has a bunch of "stock" kernel configurations for release
> engineering, our initramfs tool (genkernel), and other endeavors over
> the years. These projects claim BSD, GPL2, LGPL2 on various pieces, and
> I don't think they can all be correct. I'm working on getting them into
> one place, because some of them have been getting stale, but the
> differing licenses raised a red flag to me.
> 

 To the extent that GPL-2 can include LGPL-2 and BSD, I suggest that
you label them all as GPL-2.  That is the licence of the kernel, and
for practical reasons it will not change (this was discussed when
somebody asked about GPL-3 : even if the main copyright holders
wanted to make the change (and many do not), some copyright holders
are no longer contactable).  You might be able to dual-license some
of these distro files, but I have no idea if that would be appropriate.

ĸen
-- 
Nanny Ogg usually went to bed early. After all, she was an old lady.
Sometimes she went to bed as early as 6 a.m.
