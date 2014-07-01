Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbaGEGOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 02:14:11 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:60819 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaGEGOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 02:14:09 -0400
Message-ID: <53B282BA.6010309@gmail.com>
Date: Tue, 01 Jul 2014 11:43:22 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomi Salminen <tlsalmin@gmail.com>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org
Subject: Re: [patch] man2/fcntl.2: F_SETPIPE_SZ returns pipe size, not 0.
References: <CACV4sJ8mYEnozgDOmN7VODFrvw_51EYDgw2OxsPRq4s5fSh2Cg@mail.gmail.com>
In-Reply-To: <CACV4sJ8mYEnozgDOmN7VODFrvw_51EYDgw2OxsPRq4s5fSh2Cg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 11:05 AM, Tomi Salminen wrote:
> Hello.
> 
> I was using F_SETPIPE_SZ and noticed that fcntl was returning the
> pipe size set to it and not zero on success. I checked the kernel
> source, which seemed to return nr_pages * PAGE_SIZE; I made a patch 
> to update the man-page of fcntl, since it specified only F_GETPIPE_SZ
> as returning the pipe size and others zero.
> 
> Attaching patch made on top of commit
> f070e9543a5a7cc600229ee6a3c725804c90de91

Thanks for spotting that, Tomi. I applied a more extensive patch, below.

Cheers,

Michael

--- a/man2/fcntl.2
+++ b/man2/fcntl.2
@@ -1257,9 +1257,7 @@ When allocating the buffer for the pipe,
 the kernel may use a capacity larger than
 .IR arg ,
 if that is convenient for the implementation.
-The
-.B F_GETPIPE_SZ
-operation returns the actual size used.
+The actual capacity that is set is returned as the function result.
 Attempting to set the pipe capacity smaller than the amount
 of buffer space currently used to store data produces the error
 .BR EBUSY .
@@ -1291,7 +1289,7 @@ for traditional
 .B SIGIO
 behavior.
 .TP
-.B F_GETPIPE_SZ
+.BR F_GETPIPE_SZ ", " F_SETPIPE_SZ
 The pipe capacity.
 .TP
 All other commands


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
