Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbaDVSDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbaDVSDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:03:45 -0400
Date: Tue, 22 Apr 2014 14:03:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: peterz@infradead.org, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, eranian@google.com, andi@firstfloor.org,
        wcohen@redhat.com
Subject: mapping instructions to dynamic languages like java, python, ruby
Message-ID: <20140422180305.GK8488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was discussing recently with Will Cohen about how to get perf to
understand dynamic languages (java, python, ruby) better.  Currently, perf
samples and address, stores it in a mmap region (from the kernel side),
the mmap region is read (from user side async) and stored in a file.

During 'perf report' those instruction addresses are looked up in the
dwarf table?? of the binary they were mapped to, to resolve their symbols.

This works great for statically compiled binaries (like C), where the
addresses stay the same during each run of the binary.

However, for dynamic languages like java, python, ruby not only do those
addresses change each run of the binary, those address can change
_during_ the execution of the binary.  As a result the normal perf
collection method fails.

Oprofile has a mechanism to work around this, by creating a debug library
for java that records class information.  This library is linked?? during
the initial execution of the java program and all its symbol info is
recorded in a temp file.  During post-processing this temp file is read
back in and symbol info is obtained.

However, this approach is java specific and only works for programs that
initially start with it (can not attach to running programs).

Thoughts have come up about using a SIGPROF from the kernel to signal the
userspace interpreters to dump information to a temp file that can be used
later during post-processing.

Does anyone have any thoughts or experience on this?

Cheers,
Don

