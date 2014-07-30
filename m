Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaG3XDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:03:51 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:43293 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaG3XDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:03:50 -0400
Date: Thu, 31 Jul 2014 02:03:02 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Al Viro <viro@ZenIV.linux.org.uk>, "David S. Miller" <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, jason.low2@hp.com,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: cred_guard_mutex vs seq_file::lock [was: Re: 3.14.0+/x86:
 lockdep and mutexes not getting along]
Message-ID: <20140730230302.GA22779@node.dhcp.inet.fi>
References: <20140410142918.GU11096@twins.programming.kicks-ass.net>
 <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <26259.1397227827@warthog.procyon.org.uk>
 <20140411150724.GI18016@ZenIV.linux.org.uk>
 <20140730223130.GA22417@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730223130.GA22417@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 01:31:30AM +0300, Kirill A. Shutemov wrote:
> I don't know why we allow "chmod +x" on some proc files, notably net-related.
> Is it a bug?

# ls -l /proc/{1,157}/net/packet
-r--r--r-- 1 root 0 0 Jul 30 23:01 /proc/1/net/packet
-r--r--r-- 1 root 0 0 Jul 30 23:01 /proc/157/net/packet
# chmod +x /proc/157/net/packet
# ls -l /proc/{1,157}/net/packet
-r-xr-xr-x 1 root 0 0 Jul 30 23:02 /proc/1/net/packet
-r-xr-xr-x 1 root 0 0 Jul 30 23:02 /proc/157/net/packet

Ouch.. Or is it expected?

-- 
 Kirill A. Shutemov
