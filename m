Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaDGEOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 00:14:47 -0400
Received: from imap.thunk.org ([74.207.234.97]:50932 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaDGEOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 00:14:41 -0400
Date: Mon, 7 Apr 2014 00:14:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
Message-ID: <20140407041431.GA8468@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chen Gang <gang.chen.5i5j@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Guan Xuetao <gxt@mprc.pku.edu.cn>
References: <53396AC1.10108@gmail.com>
 <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 03:39:09PM +0200, Geert Uytterhoeven wrote:
> On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> > '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Need
> > append 'ULL' for it.
> >
> > The related warning (with allmodconfig under unicore32):
> >
> >     CC [M]  fs/ext4/extents_status.o
> >   fs/ext4/extents_status.c: In function ‘__es_remove_extent’:
> >   fs/ext4/extents_status.c:813: warning: integer constant is too large for ‘long’ type
> 
> Thanks! This is failing on all 32-bit architectures.

Yes, it's harmless (since we don't actually check the value anywhere;
this is just so humans could easily spot bugs when debugging), but
I'll make sure this gets queued for 3.15 fixes in the ext4 tree.

Thanks!!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
