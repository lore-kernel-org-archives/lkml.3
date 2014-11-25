Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaKYSKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:10:44 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:46418 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKYSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:10:41 -0500
Date: Tue, 25 Nov 2014 10:10:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: rdunlap@infradead.org, pieter@boesman.nl, josh@joshtriplett.org,
        alexander.h.duyck@intel.com, viro@zeniv.linux.org.uk, ast@plumgrid.com,
        akpm@linux-foundation.org, beber@meleeweb.net,
        catalina.mocanu@gmail.com, dborkman@redhat.com, edumazet@google.com,
        ebiederm@xmission.com, fabf@skynet.be,
        fuse-devel@lists.sourceforge.net, geert@linux-m68k.org,
        hughd@google.com, iulia.manda21@gmail.com, JBeulich@suse.com,
        bfields@fieldses.org, jlayton@poochiereds.net,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        mcgrof@suse.com, mattst88@gmail.com, mgorman@suse.de, mst@redhat.com,
        miklos@szeredi.hu, netdev@vger.kernel.org, oleg@redhat.com,
        Paul.Durrant@citrix.com, pefoley2@pefoley.com, tgraf@suug.ch,
        therbert@google.com, trond.myklebust@primarydata.com,
        willemb@google.com, xiaoguangrong@linux.vnet.ibm.com,
        zhenglong.cai@cs2c.com.cn
Subject: Re: [PATCH v4 0/7] kernel tinification: optionally compile out
 splice family of syscalls (splice, vmsplice, tee and sendfile)
Message-ID: <20141125181032.GJ5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1416870079-15254-1-git-send-email-pieter@boesman.nl>
 <5474ABB6.3030400@infradead.org>
 <20141125.121305.2094097848188324942.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125.121305.2094097848188324942.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112518-0025-0000-0000-000006613C45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:13:05PM -0500, David Miller wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Tue, 25 Nov 2014 08:17:58 -0800
> 
> > Is the splice family of syscalls the only one that tiny has identified
> > for optional building or can we expect similar treatment for other
> > syscalls?
> > 
> > Why will many embedded systems not need these syscalls?  You know
> > exactly what apps they run and you are positive that those apps do
> > not use splice?
> 
> I think starting to compile out system calls is a very slippery
> slope we should not begin the journey down.
> 
> This changes the forward facing interface to userspace.

I certainly sympathize with this concern, given the importance of software
portability.  However, the tiny-hardware alternative appears ot some sort
of special-purpose embedded OS, which most definitely will suffer from
software compatibility issues.  I guess that the good news is that much
of the tiny hardware that used to be 8 or 16 bits is now 32 bits, which
means that it has at least some chance of running some form of Linux.  ;-)

							Thanx, Paul

