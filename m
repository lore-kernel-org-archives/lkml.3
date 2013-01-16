Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3APJKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:10:10 -0500
Received: from re04.intra2net.com ([82.165.46.26]:55222 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3APJKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:10:02 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re: [perf PATCH] Use pclose() instead of fclose() on pipe stream
Date: Wed, 16 Jan 2013 10:09:48 +0100
Message-ID: <1798138.DOH3quA1zP@storm>
Organization: Intra2net AG
User-Agent: KMail/4.9.5 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130111041603.GB3054@ghostprotocols.net>
References: <50D9CDFC.3010101@intra2net.com> <20130111041603.GB3054@ghostprotocols.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Friday, 11. January 2013 01:16:03 you wrote:
> > Also fix descriptor leak on error
> > 
> > Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> > ---
> > 
> >  tools/perf/util/sort.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> After applying this:
> 
>     CC /home/acme/git/build/perf/util/cpumap.o
> cc1: warnings being treated as errors
> util/sort.c: In function ‘hist_entry__srcline_snprintf’:
> util/sort.c:254: error: ‘fp’ may be used uninitialized in this function
> make: *** [/home/acme/git/build/perf/util/sort.o] Error 1

Alright, looks like I've messed up the "early" error path.
The "FILE *fp" pointer needs to be initialized to NULL.

Should I send another patch or do you want to fix it on the fly?

What about the other patch
"[perf PATCH] Fix possible (unlikely) buffer overflow"

?

Cheers,
Thomas

