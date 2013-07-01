Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3GAUpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:45:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3GAUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:45:17 -0400
Date: Mon, 1 Jul 2013 13:45:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 4/4] selftests: get {cpu,memory}-hotplug tests to run
Message-Id: <20130701134516.6f043ea9b30ed4fd161704ad@linux-foundation.org>
In-Reply-To: <1372596791-12968-5-git-send-email-artagnon@gmail.com>
References: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
	<1372596791-12968-5-git-send-email-artagnon@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jun 2013 18:23:11 +0530 Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> The cpu-hotplug and memory-hotplug tests don't run:
> 
>   $ sudo make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
>   /bin/sh: ./on-off-test.sh: Permission denied
> 
>   $ sudo make -C tools/testing/selftests TARGETS=memory-hotplug run_tests
>   /bin/sh: ./on-off-test.sh: Permission denied
> 
> Flip the executable bit fixing this.
> 
> ...
>
>  2 files changed, 0 insertions(+), 0 deletions(-)
>  mode change 100644 => 100755 tools/testing/selftests/cpu-hotplug/on-off-test.sh
>  mode change 100644 => 100755 tools/testing/selftests/memory-hotplug/on-off-test.sh
> 
> diff --git a/tools/testing/selftests/cpu-hotplug/on-off-test.sh b/tools/testing/selftests/cpu-hotplug/on-off-test.sh
> old mode 100644
> new mode 100755
> diff --git a/tools/testing/selftests/memory-hotplug/on-off-test.sh b/tools/testing/selftests/memory-hotplug/on-off-test.sh
> old mode 100644
> new mode 100755

That won't work.  The x bit will too easily get lost again - for
example, patch(1) will rub it out.

This:

--- a/tools/testing/selftests/cpu-hotplug/Makefile~tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts
+++ a/tools/testing/selftests/cpu-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
+	@/bin/sh ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
 clean:
--- a/tools/testing/selftests/memory-hotplug/Makefile~tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts
+++ a/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
+	@/bin/sh ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
_

