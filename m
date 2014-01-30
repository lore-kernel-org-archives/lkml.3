Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaA3Fcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:32:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaA3Fcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:32:42 -0500
Date: Thu, 30 Jan 2014 00:32:32 -0500
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20140130053232.GA14856@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140130041622.GA23875@redhat.com>
 <cbf0c86a-317e-451f-9bb4-48c582ab4e1e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbf0c86a-317e-451f-9bb4-48c582ab4e1e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 11:50:43PM -0500, Steven Rostedt wrote:
 > Are you running as root?  If not, you found another way to get perf to start function tracing.

Good point. In this case, I was trying some new experimental trinity code
that starts as root, generates fd's, then drops privs before doing syscalls.

So the "generate fds" part did some perf_event_open's as root, yeah.

While that's less scary from a security pov than it was last time, it's still
something that aparently needs fixing.

	Dave


