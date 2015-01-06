Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbbAFAOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:14:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbbAFAON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:14:13 -0500
Date: Mon, 5 Jan 2015 16:14:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiran Raparthy <kiran.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v4] debug: prevent entering debug mode on panic/exception.
Message-Id: <20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>
In-Reply-To: <1419338309-16729-1-git-send-email-kiran.kumar@linaro.org>
References: <1419338309-16729-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014 18:08:29 +0530 Kiran Raparthy <kiran.kumar@linaro.org> wrote:

> From: Colin Cross <ccross@android.com>
> 
> debug: prevent entering debug mode on panic/exception.
> 
> On non-developer devices, kgdb prevents the device from rebooting
> after a panic.
> 
> Incase of panics and exceptions, to allow the device to reboot, prevent
> entering debug mode to avoid getting stuck waiting for the user to interact
> with debugger.
> 
> To avoid entering the debugger on panic/exception without any extra
> configuration, panic_timeout is being used which can be set via
> /proc/sys/kernel/panic at run time and CONFIG_PANIC_TIMEOUT sets the default
> value.
> 
> ...
>

hm.  Why overload the meaning of panic_timeout in this fashion?  If
someone is using kgdb and has panic_timeout set, they'll get quiet a
surprise.

Would it be cleaner/clearer to add some new standalone control for
this?  One which is only present if CONFIG_KGDB.


We appear to have forgotten to document panic_timeout.  Sigh.
