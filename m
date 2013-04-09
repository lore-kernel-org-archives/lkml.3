Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935572Ab3DIW0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:26:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52106 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3DIW0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:26:30 -0400
Date: Tue, 9 Apr 2013 15:25:37 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: perf --version inconsistency
Message-ID: <20130409222537.GA26160@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040922-3620-0000-0000-000001F66341
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following commit replaced 'git describe' with 'git tag -l | tail -1'
to speed up the build:

	commit acddedfba0df1e47fa99035a04661082b679ee9c
	Author: Ingo Molnar <mingo@kernel.org>
	Date:   Tue Oct 30 09:46:00 2012 +0100

	perf tools: Speed up the perf build time by simplifying the perf
	--version string generation

If we checkout an older commit and build perf, the version reported by 'perf'
ends up being inconsistent:

	$ git describe
	v3.8-rc7

	$ git show --pretty=short 
	commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39
	Author: Linus Torvalds <torvalds@linux-foundation.org>

	    Linux 3.8-rc7

	$ git tag -l | tail -1
	v3.9-rc4

	$ cd tools/perf; make perf

	$ ./perf --version
	perf version 3.9.rc4.g836dc9e

where commit id '836dc9e' corresponds to 'v3.8-rc7' rather than '3.9.rc4'.

Is the tag reported by 'perf --version' meant to be approximate ?

Wonder if we can do anything on the 'git' side to cache the tag associated
with HEAD and update the cache at each 'git checkout'. That could slow
down 'git checkout' though.

Sukadev

