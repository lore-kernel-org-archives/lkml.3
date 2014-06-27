Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaF0Tpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:45:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaF0Tpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:45:54 -0400
Date: Fri, 27 Jun 2014 12:45:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuah.kh@samsung.com
Cc: gregkh@linuxfoundation.org, keescook@chromium.org, michael@ellerman.id.au,
        fweisbec@gmail.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: selftests - create a separate hotplug target
Message-Id: <20140627124552.d834ecd58c416c0a2d0dae02@linux-foundation.org>
In-Reply-To: <53ADA58D.4070307@samsung.com>
References: <1403814836-16964-1-git-send-email-shuah.kh@samsung.com>
	<20140626145106.83d8a15bfa07270b00e5d24b@linux-foundation.org>
	<53ADA58D.4070307@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 11:10:37 -0600 Shuah Khan <shuah.kh@samsung.com> wrote:

> On 06/26/2014 03:51 PM, Andrew Morton wrote:
> > On Thu, 26 Jun 2014 14:33:56 -0600 Shuah Khan <shuah.kh@samsung.com> wrote:
> >
> >> On some systems, hotplug tests could hang forever waiting for cpu and
> >> memory to be ready to be offlined. A special hotplug target is created,
> >> which will help run non-hotplug tests and run hotplug tests as a special
> >> case. Individual hotplug tests can still be run as a special target
> >> targeted for a single subsystem.
> >
> > This is a bit sad.  The general philosophy with selftests is that they
> > should run to completion even if the kernel/hardware which they are
> > testing isn't available - they should work it out for themselves.
> >
> > But that's obviously a problem with hotplug.  And with networking or
> > anything else which needs external action.
> >
> > On the other hand, networking has loopback and the kernel supports cpu
> > hotplug simulation via procfs.  So perhaps the cpu and memory hotplug
> > tests should be redone so they do the plug/unplug injection themselves,
> > so they can run without external intervention?
> 
> Changing/running the tests in a safe mode (least possibility of hang)
> mode is another option. This way the tests are run in normal mode with
> reduced scope. Memory hotplug test has the ratio option and when I
> specified low ratio 1-5%, it completed in a few seconds.
> 
> cpu-hotplug test will require changes. I am working on a change to
> offline a user specified # of cpus instead offlining all hotpluggable
> cpus and then onlining them again at the end of the test.
> 
> When all selftests are run, safe mode hotplug tests will be run.
> 
> Does this approach sound reasonable?

I don't know really.  You know more about this than I - what advantages
does the separate-make-target approach have over this approach?

