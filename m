Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3JaQSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:18:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51328 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3JaQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:18:41 -0400
Date: Thu, 31 Oct 2013 16:18:26 +0000
From: Jamie Iles <jamie.iles@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jamie Iles <jamie.iles@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] recordmcount.pl: add support for __fentry__
Message-ID: <20131031161826.GH29371@localhost>
References: <1383235198-24961-1-git-send-email-jamie.iles@oracle.com>
 <20131031120926.112c3c26@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031120926.112c3c26@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:09:26PM -0400, Steven Rostedt wrote:
> On Thu, 31 Oct 2013 15:59:58 +0000
> Jamie Iles <jamie.iles@oracle.com> wrote:
> 
> > With gcc 4.6.0 the -mfentry feature places the function profiling call
> > at the start of the function. When this is used, the call is to
> > __fentry__ and not mcount.
> > 
> > Based on 48bb5dc6cd9d30fe0d594947563da1f8bd9abada (ftrace: Make
> > recordmcount.c handle __fentry__).
> 
> Why? All current users of __fentry__ use the C version of recordmcount.
> This just slows down the few archs that still use recordmcount.pl.

Okay, it's probably fair to drop this one then if it's not useful to the 
other arches.  We have a corner case with Ksplice where the C version of 
mcount not writing the section symbol for __mcount_loc causes a problem 
and we fall back to the perl version, but I'll spend some time working 
on fixing that instead.

Thanks,

Jamie
