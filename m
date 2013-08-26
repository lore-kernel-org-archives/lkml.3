Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3HZTtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3HZTto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:49:44 -0400
Date: Mon, 26 Aug 2013 15:49:24 -0400
From: Dave Jones <davej@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130826194923.GA1549@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Ahern <dsahern@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130826145838.GA8377@redhat.com>
 <20130826162928.GQ3871@linux.vnet.ibm.com>
 <20130826133041.3d750b1b@gandalf.local.home>
 <20130826175012.GA25202@redhat.com>
 <20130826141814.54dcaa89@gandalf.local.home>
 <20130826182907.GB25202@redhat.com>
 <521BAFD3.2060404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521BAFD3.2060404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 01:43:15PM -0600, David Ahern wrote:
 > On 8/26/13 12:29 PM, Dave Jones wrote:
 > > On Mon, Aug 26, 2013 at 02:18:14PM -0400, Steven Rostedt wrote:
 > >   > On Mon, 26 Aug 2013 13:50:12 -0400
 > >   > Dave Jones <davej@redhat.com> wrote:
 > >   > >
 > >   > > This was triggered as a regular user fwiw.
 > >   > > I had not been running perf, or any other tracing. It was just left
 > >   > > fuzzing over the weekend with no interaction at all.
 > >   >
 > >   > So you are telling me that ftrace was enabled by a regular user? If so,
 > >   > that's a huge issue.
 > >
 > > quite.
 > >
 > >   > So my question to you. If you were not running perf or any other
 > >   > tracing, and this is all just non-root user. How the hell did perf
 > >   > function tracing get started on your box????
 > >
 > > What mechanisms are available that would trigger it being enabled ?
 > >
 > > Is there some path through sys_perf_open_event that might be
 > > missing a capability check perhaps ?
 > 
 > Do you have /sys/kernel/debug with access permissions?

Ah, yeah, that'll be it. Good catch.

Sorry for the false alarm Steve ;)

	Dave

