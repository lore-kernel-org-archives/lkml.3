Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3KGW7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:59:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9363 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753536Ab3KGW7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:59:42 -0500
Date: Thu, 7 Nov 2013 17:59:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131107175937.37c224bb@gandalf.local.home>
In-Reply-To: <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
	<1383860919-1883-4-git-send-email-jack@suse.cz>
	<CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013 23:43:52 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:


> When a message takes tens of seconds to be printed, it usually means
> we are in trouble somehow :)
> I wonder what printk source can trigger such a high volume.

The only ones that I'm aware of is the prints from sysrq. Which
includes a ftrace_dump as well. These have caused issues in the past,
but usually I do them on boxes that I reboot afterward anyway.

-- Steve
