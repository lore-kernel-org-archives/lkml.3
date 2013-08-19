Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab3HSOFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:05:08 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59632 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3HSOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:05:06 -0400
Date: Mon, 19 Aug 2013 11:05:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] perf ui/gtk: Separate out GTK code to a shared
 object (v4)
Message-ID: <20130819140500.GA3053@ghostprotocols.net>
References: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 09, 2013 at 03:28:06PM +0900, Namhyung Kim escreveu:
> This is v3 of gtk code separation patchset to reduce library

Not a major problem, but would be good if we were robust in this area:

    LINK /tmp/build/perf/perf
/usr/bin/ld: /tmp/build/perf/ui/gtk/browser.o: relocation R_X86_64_32
against `.rodata.str1.1' can not be used when making a shared object;
recompile with -fPIC
/tmp/build/perf/ui/gtk/browser.o: could not read symbols: Bad value
collect2: error: ld returned 1 exit status
make: *** [/tmp/build/perf/libperf-gtk.so] Error 1
make: *** Waiting for unfinished jobs....
make: Leaving directory `/home/git/linux/tools/perf'
[acme@zoo linux]$ 

This happened because I was retesting the whole series after noticing I
was testing as root, that has a symlink of ~acme/bin/perf to
~root/bin/perf but was lacking a symlink of ~acme/lib64/ to
~root/lib64/, so that as root perf could find the libperf-gtk.so file.

So I just rolled back the 3 patches in this series to rebuild and
retried, but when I reapplied the first patch in this series I got the
above error, i.e. the make process got confused and didn't properly
rebuilt a file in the expected format for linking, after forcefully
removing my build dir and rebuilding everything it got back to working.

But I expected that after the first patch 'perf --gtk' would work, and
it doesn't.

Now even after I applied the whole series I don't get --gtk to work,
neither as a non-root nor as root :-\

Investigating...

- Arnaldo
