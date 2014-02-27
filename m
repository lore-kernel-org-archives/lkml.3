Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaB0Ews (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:52:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:53946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbaB0Ewr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:52:47 -0500
Message-ID: <1393476762.5519.35.camel@marge.simpson.net>
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
From: Mike Galbraith <bitbucket@online.de>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 27 Feb 2014 05:52:42 +0100
In-Reply-To: <20140227034535.GC14346@milliways>
References: <20140227005246.GB10367@milliways>
	 <1393471595.5519.22.camel@marge.simpson.net>
	 <20140227034535.GC14346@milliways>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:lU1tbv0YxJ5S94mXXTSu+a0O9ZOtMcX89Sz5B6AZUG0
 z54U5EyY9MakH7dzP1BNFLz0LiTKQ7NfjLhsPXWRp1X1eX0T5W
 MBEavN1KSB8qsHMlTHLWSv3QAwFPm65Fkbtf/pwbyAaJaLNH9F
 7iFtfHqLUeGO1TBbHD6VYmRkHoxdlHbJSr1SChA1ePRrjpqZhC
 SfXSoIE3SbfYddqKQvfwxQm7z3aB9hguuPKDAZk76YRHgfCBbZ
 LdaNlrGNsxyQfWlW0wum3B2mHj0U+tVliYhlC6Jyzd03yYMrdk
 VXW9iXocBbQvOXTlkgAPn2oz8lszd9iDoayza4dOl0VnU0uC+F
 0K3zhN+HFBT2XZ6lxTaplF5SzLfe22Ncb/LRQBYIsUQG1MZ++Q
 5EDD5UvbEoOEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 03:45 +0000, Ken Moffat wrote: 
> On Thu, Feb 27, 2014 at 04:26:35AM +0100, Mike Galbraith wrote:
> > 
> > I would start with strace to see if a task is looping in userspace, then
> > move on to perf top -g -p <pid> (or perf record/report) to peek at what
> > it's up to in the kernel.  Once you have the where, trace_printk() is
> > the best thing since sliced bread (which ranks just below printk()).
> > 
> > -Mike
>  Thanks.  I'll need to build perf.

You may want to build the kernel with frame-pointers too, for easy gdb
list *0x(hexnum) of *func()+0x(hexoffset) use.  Crash is also pretty
handy both for rummaging live via crash vmlinux /proc/kcore, and for
leisurely postmortem analysis if you set the box up to crashdump in
advance, and force a dump (poke sysrq-c or echo c > /proc/sysrq-trigger)
when you see the bad thing happen.  Crash has all kinds of goodies,
including invocation of gdb.

-Mike

