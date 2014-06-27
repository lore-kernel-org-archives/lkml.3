Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaF0UEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:04:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaF0UEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:04:12 -0400
Date: Fri, 27 Jun 2014 13:04:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuah.kh@samsung.com
Cc: gregkh@linuxfoundation.org, keescook@chromium.org, michael@ellerman.id.au,
        fweisbec@gmail.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: selftests - create a separate hotplug target
Message-Id: <20140627130411.d351b6543787b826f5ba1b34@linux-foundation.org>
In-Reply-To: <53ADCD3B.3000209@samsung.com>
References: <1403814836-16964-1-git-send-email-shuah.kh@samsung.com>
	<20140626145106.83d8a15bfa07270b00e5d24b@linux-foundation.org>
	<53ADA58D.4070307@samsung.com>
	<20140627124552.d834ecd58c416c0a2d0dae02@linux-foundation.org>
	<53ADCD3B.3000209@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 13:59:55 -0600 Shuah Khan <shuah.kh@samsung.com> wrote:

> > I don't know really.  You know more about this than I - what advantages
> > does the separate-make-target approach have over this approach?
> >
> 
> Currently these tests run with full range - i.e try to offline
> all cpus that are hotpluggable and try to offline all memory
> that is hotpluggable. This results in hangs.
> 
> Creating a separate target the way I did it in this patch excludes these
> tests all together. i.e when somebody runs:
> 
> make -C tools/testing/selftests run_tests
> 
> hotplug tests don't run.
> 
> Instead, with a few changes, tests can be run with a reduced scope so
> a % of the memory gets offlined as opposed to all of it and the same
> thing with cpus. This way hotplug code gets tested as opposed to
> being excluded in a default test run case.
> 
> However, if limited scope testing isn't useful, separate target is
> better until tests can be made safe to run without hangs.

hm, OK.  So it sounds like the best solution would be to run the
limited tests by default and to require special intervention to run the
full tests.

I guess a separate make target is a suitable way of running the full
tests.  We could use an environment variable or various other things.

