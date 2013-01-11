Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3AKUTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:19:39 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:57502 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3AKUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:19:37 -0500
Date: Fri, 11 Jan 2013 01:16:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [perf PATCH] Use pclose() instead of fclose() on pipe stream
Message-ID: <20130111041603.GB3054@ghostprotocols.net>
References: <50D9CDFC.3010101@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50D9CDFC.3010101@intra2net.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 25, 2012 at 05:02:04PM +0100, Thomas Jarosch escreveu:
> cppcheck message:
> [tools/perf/util/sort.c:277]: (error) Mismatching allocation and deallocation: fp
> 
> Also fix descriptor leak on error
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  tools/perf/util/sort.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

After applying this:

    CC /home/acme/git/build/perf/util/cpumap.o
cc1: warnings being treated as errors
util/sort.c: In function ‘hist_entry__srcline_snprintf’:
util/sort.c:254: error: ‘fp’ may be used uninitialized in this function
make: *** [/home/acme/git/build/perf/util/sort.o] Error 1

- Arnaldo
