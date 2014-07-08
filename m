Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaGHWbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:31:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaGHWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:31:14 -0400
Date: Tue, 8 Jul 2014 15:31:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, keescook@chromium.org, michael@ellerman.id.au,
        benh@kernel.crashing.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 linux-next] tools: selftests - create a separate
 hotplug target for full range test
Message-Id: <20140708153112.494e5f769f9ae9184fad66cd@linux-foundation.org>
In-Reply-To: <1404316298-8870-1-git-send-email-shuah.kh@samsung.com>
References: <1404316298-8870-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Jul 2014 09:51:38 -0600 Shuah Khan <shuah.kh@samsung.com> wrote:

> On some systems, hot-plug tests could hang forever waiting for cpu and
> memory to be ready to be offlined. A special hot-plug target is created
> to run full range of hot-plug tests. In default mode, hot-plug tests run
> in safe mode with a limited scope. In limited mode, cpu-hotplug test is
> run on a single cpu as opposed to all hotplug capable cpus, and memory
> hotplug test is run on 2% of hotplug capable memory instead of 10%. In
> addition to the above change, cpu-hotplug is chnged to change processor
> affinity to cpu 0 so it doesn't impact itself while the test runs.
> 
> ...
>
> --- a/tools/testing/selftests/README.txt
> +++ b/tools/testing/selftests/README.txt
> @@ -4,8 +4,15 @@ The kernel contains a set of "self tests" under the tools/testing/selftests/
>  directory. These are intended to be small unit tests to exercise individual
>  code paths in the kernel.
>  
> -Running the selftests
> -=====================
> +On some systems, hot-plug tests could hang forever waiting for cpu and
> +memory to be ready to be offlined. A special hot-plug target is created
> +to run full range of hot-plug tests. In default mode, hot-plug tests run
> +in safe mode with a limited scope. In limited mode, cpu-hotplug test is
> +run on a single cpu as opposed to all hotplug capable cpus, and memory
> +hotplug test is run on 2% of hotplug capable memory instead of 10%.
> +
> +Running the selftests (hotplug tests are run in limited mode)
> +=============================================================
>  
>  To build the tests:
>  
> @@ -18,14 +25,26 @@ To run the tests:
>  
>  - note that some tests will require root privileges.
>  
> -
> -To run only tests targetted for a single subsystem:
> +To run only tests targeted for a single subsystem: (including
> +hotplug targets in limited mode)
>  
>    $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
>  
>  See the top-level tools/testing/selftests/Makefile for the list of all possible
>  targets.
>  
> +Running the full range hotplug selftests
> +========================================
> +
> +To build the tests:
> +
> +  $ make -C tools/testing/selftests hotplug

Well.  `make -C tools/testing/selftests' will build the hotplug tests,
won't it?  We may as well *compile* everything by default..

> 
> ...
>

