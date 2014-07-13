Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaGMP3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 11:29:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47331 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbaGMP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 11:29:14 -0400
Date: Sun, 13 Jul 2014 08:28:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:RCUTORTURE TEST F..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcutorture: use bash shell for all the test scripts
Message-ID: <20140713152827.GF16041@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405114309-17548-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405114309-17548-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071315-8236-0000-0000-000003CF3CAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 05:31:27PM -0400, Pranith Kumar wrote:
> Some of the scripts encode a default /bin/sh shell. On systems which use dash as
> default shell, these scripts fail as they are bash scripts. I encountered this
> while testing the sprintf() changes on a Debian system where dash is the default
> shell.
> 
> This commit changes all such uses to use bash explicitly.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued with Josh's Reviewed-by, thank you both!

One nit: In the future, please capitalize the word following the ":"
in the subject line.  So, instead of:

	[PATCH 1/1] rcutorture: use bash shell for all the test scripts

Write:

	[PATCH 1/1] rcutorture: Use bash shell for all the test scripts

I fixed this one and will fix your later permissions patch, but again,
please use this convention in future patches.

							Thanx, Paul

> ---
>  tools/testing/selftests/rcutorture/bin/config2frag.sh      | 4 ++--
>  tools/testing/selftests/rcutorture/bin/configcheck.sh      | 4 ++--
>  tools/testing/selftests/rcutorture/bin/configinit.sh       | 4 ++--
>  tools/testing/selftests/rcutorture/bin/kvm-build.sh        | 2 +-
>  tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh | 2 +-
>  tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh  | 2 +-
>  tools/testing/selftests/rcutorture/bin/kvm-recheck.sh      | 2 +-
>  tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh   | 2 +-
>  tools/testing/selftests/rcutorture/bin/kvm.sh              | 2 +-
>  tools/testing/selftests/rcutorture/bin/parse-build.sh      | 4 ++--
>  tools/testing/selftests/rcutorture/bin/parse-console.sh    | 4 ++--
>  tools/testing/selftests/rcutorture/bin/parse-torture.sh    | 4 ++--
>  12 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/rcutorture/bin/config2frag.sh b/tools/testing/selftests/rcutorture/bin/config2frag.sh
> index 9f9ffcd..4e394ef 100644
> --- a/tools/testing/selftests/rcutorture/bin/config2frag.sh
> +++ b/tools/testing/selftests/rcutorture/bin/config2frag.sh
> @@ -1,5 +1,5 @@
> -#!/bin/sh
> -# Usage: sh config2frag.sh < .config > configfrag
> +#!/bin/bash
> +# Usage: bash config2frag.sh < .config > configfrag
>  #
>  # Converts the "# CONFIG_XXX is not set" to "CONFIG_XXX=n" so that the
>  # resulting file becomes a legitimate Kconfig fragment.
> diff --git a/tools/testing/selftests/rcutorture/bin/configcheck.sh b/tools/testing/selftests/rcutorture/bin/configcheck.sh
> index d686537..6173ed5 100755
> --- a/tools/testing/selftests/rcutorture/bin/configcheck.sh
> +++ b/tools/testing/selftests/rcutorture/bin/configcheck.sh
> @@ -1,5 +1,5 @@
> -#!/bin/sh
> -# Usage: sh configcheck.sh .config .config-template
> +#!/bin/bash
> +# Usage: bash configcheck.sh .config .config-template
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
> index 9c3f3d3..d8f7418 100755
> --- a/tools/testing/selftests/rcutorture/bin/configinit.sh
> +++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
> @@ -1,6 +1,6 @@
> -#!/bin/sh
> +#!/bin/bash
>  #
> -# sh configinit.sh config-spec-file [ build output dir ]
> +# bash configinit.sh config-spec-file [ build output dir ]
>  #
>  # Create a .config file from the spec file.  Run from the kernel source tree.
>  # Exits with 0 if all went well, with 1 if all went well but the config
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> index 7c1e56b..e4bfb91 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> @@ -2,7 +2,7 @@
>  #
>  # Build a kvm-ready Linux kernel from the tree in the current directory.
>  #
> -# Usage: sh kvm-build.sh config-template build-dir more-configs
> +# Usage: bash kvm-build.sh config-template build-dir more-configs
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
> index 7f1ff1a..30cbb63 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
> @@ -2,7 +2,7 @@
>  #
>  # Analyze a given results directory for locktorture progress.
>  #
> -# Usage: sh kvm-recheck-lock.sh resdir
> +# Usage: bash kvm-recheck-lock.sh resdir
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
> index 307c4b9..6e94a5e 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
> @@ -2,7 +2,7 @@
>  #
>  # Analyze a given results directory for rcutorture progress.
>  #
> -# Usage: sh kvm-recheck-rcu.sh resdir
> +# Usage: bash kvm-recheck-rcu.sh resdir
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
> index 3f6c9b7..3482b3f 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
> @@ -4,7 +4,7 @@
>  # check the build and console output for errors.  Given a directory
>  # containing results directories, this recursively checks them all.
>  #
> -# Usage: sh kvm-recheck.sh resdir ...
> +# Usage: bash kvm-recheck.sh resdir ...
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> index 0f69dcb..5c265da 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> @@ -6,7 +6,7 @@
>  # Execute this in the source tree.  Do not run it as a background task
>  # because qemu does not seem to like that much.
>  #
> -# Usage: sh kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
> +# Usage: bash kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
>  #
>  # qemu-args defaults to "-nographic", along with arguments specifying the
>  #			number of CPUs and other options generated from
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
> index 589e9c3..ff147ad 100644
> --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> @@ -7,7 +7,7 @@
>  # Edit the definitions below to set the locations of the various directories,
>  # as well as the test duration.
>  #
> -# Usage: sh kvm.sh [ options ]
> +# Usage: bash kvm.sh [ options ]
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/parse-build.sh b/tools/testing/selftests/rcutorture/bin/parse-build.sh
> index 5432309..41eeeef 100755
> --- a/tools/testing/selftests/rcutorture/bin/parse-build.sh
> +++ b/tools/testing/selftests/rcutorture/bin/parse-build.sh
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  #
>  # Check the build output from an rcutorture run for goodness.
>  # The "file" is a pathname on the local system, and "title" is
> @@ -7,7 +7,7 @@
>  # The file must contain kernel build output.
>  #
>  # Usage:
> -#	sh parse-build.sh file title
> +#	bash parse-build.sh file title
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
> index 4185d4c..2517eae 100755
> --- a/tools/testing/selftests/rcutorture/bin/parse-console.sh
> +++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
> @@ -1,11 +1,11 @@
> -#!/bin/sh
> +#!/bin/bash
>  #
>  # Check the console output from an rcutorture run for oopses.
>  # The "file" is a pathname on the local system, and "title" is
>  # a text string for error-message purposes.
>  #
>  # Usage:
> -#	sh parse-console.sh file title
> +#	bash parse-console.sh file title
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> diff --git a/tools/testing/selftests/rcutorture/bin/parse-torture.sh b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
> index 3455560..bbec40b 100755
> --- a/tools/testing/selftests/rcutorture/bin/parse-torture.sh
> +++ b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  #
>  # Check the console output from a torture run for goodness.
>  # The "file" is a pathname on the local system, and "title" is
> @@ -8,7 +8,7 @@
>  # with other dmesg text, as in console-log output.
>  #
>  # Usage:
> -#	sh parse-torture.sh file title
> +#	bash parse-torture.sh file title
>  #
>  # This program is free software; you can redistribute it and/or modify
>  # it under the terms of the GNU General Public License as published by
> -- 
> 1.9.1
> 

