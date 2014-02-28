Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaB1Ufp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:35:45 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50398 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaB1Ufo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:35:44 -0500
Date: Fri, 28 Feb 2014 23:32:08 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yann Collet <yann.collet.73@gmail.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chanho Min <chanho.min@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: lz4 improvements backporting from official repository
Message-ID: <20140228203208.GA2248@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry if it's been discussed a number of times already.

Currently used LZ4 compression implementation based on svn revision r90
(at least this is what commit c72ac7a1a926 "lib: add lz4 compressor module"
says) from 3rd party repository: http://lz4.googlecode.com/svn/trunk/

I just checked out that repository and lz4 now on revision r113. The svn log
shows that there have been a number of performance improvements and fixes,
e.g.

------------------------------------------------------------------------
r113 | yann.collet.73@gmail.com | 2014-02-04 17:11:10 +0300 (Tue, 04 Feb 2014) | 5 lines

Large decompression speed improvement for GCC 32-bits. Thanks to Valery Croizier !
LZ4HC : Compression Level is now a programmable parameter (CLI from 4 to 9)
Separated IO routines from command line (lz4io.c)
Version number into lz4.h (suggested by Francesc Alted)

[..]
------------------------------------------------------------------------
r101 | yann.collet.73@gmail.com | 2013-08-12 11:35:52 +0300 (Mon, 12 Aug
2013) | 9 lines

Removed dependency to "lz4_encoder.h" and "lz4hc_encoder.h"
Improved speed of LZ4_decompress_fast() with GCC
Improved speed of LZ4_decompress_safe() for 32-bits
Made the fast LZ4 compression compatible with low-memory systems (buffer
address < 64K). Thanks Francois Gretief for report and suggestion.
[..]

and so on.


I wonder does anybody keep an eye on that improvements? Is there any
'standard' procedure of backporting/cherry-picking commits from 3rd party
repositories?

thanks,
	-ss
