Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab3JAEUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 00:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab3JAEUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 00:20:36 -0400
Date: Tue, 1 Oct 2013 00:20:25 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20131001042025.GA7038@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130828034627.GA30596@redhat.com>
 <20130828095408.37c3dd83@gandalf.local.home>
 <20130828095833.103ccdf0@gandalf.local.home>
 <20130828111746.35369b84@gandalf.local.home>
 <20130828182710.GA14103@redhat.com>
 <20130828182902.GB14103@redhat.com>
 <20130828152745.18a73c4e@gandalf.local.home>
 <20130930171201.GA10474@redhat.com>
 <1380599766.16752.6.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380599766.16752.6.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 11:56:06PM -0400, Steven Rostedt wrote:
 
 > > Steve, any further thoughts on this ? I can't do more than a few hours of fuzz-testing
 > > without eventually running into this.
 > 
 > I'm currently traveling, but as it seems that you have a pretty good
 > reproducer, can trace what trinity does up to the point it crashes?
 > 
 > I think we can do that with other buffers. If you download the latest
 > trace-cmd, you can run:
 > 
 > trace-cmd record -e syscalls -B trinity trinity <args>
 > 
 > This will create a ftrace sub buffer called trinity and shouldn't be
 > affected by the other ftrace functions. Then it should trace all the
 > syscalls that trinity does. I guess a strace could be used too.

It seems like trace-cmd needs to be run as root. all hell will break loose if trinity gets root privs.

	Dave

