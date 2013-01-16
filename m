Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3APPsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:48:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab3APPsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:48:09 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=oS6VeJ3zRZwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ylgaL1uFd_sA:10 a=muxWsHHWUX7mRpHXLX0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358351287.4068.47.camel@gandalf.local.home>
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, alan@linux.intel.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Jan 2013 10:48:07 -0500
In-Reply-To: <20130116153911.GB1329@kroah.com>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
	 <20130116064735.GA7743@kroah.com> <50F6AD15.708@suse.cz>
	 <20130116153911.GB1329@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 07:39 -0800, Greg KH wrote:

> > I intentionally ignored that one as at the time of sending the patches,
> > it was marked as BROKEN in -next. It is still broken, since it does not
> > even have a tty_port for each port which is a requirement for a while
> > already. That is also a prerequisite to fix the build failure.
> 
> It used to be marked BROKEN, I'll go do that now again to solve this
> issue.

Yeah, it use to be marked broken because it broke other archs because it
has x86 specific code, but that should have been solved with the depends
on x86 (which I still need to fix so that it works for other archs).

This now looks like it broke due to kernel ABI changes, and the driver
was ignored as it was marked BROKEN due to the non-x86 issues.

In other words, it's now broken only because it was broken before ;-)

-- Steve


