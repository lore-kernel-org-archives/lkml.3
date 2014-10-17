Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaJQGZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 02:25:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:56727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaJQGZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 02:25:21 -0400
Date: Fri, 17 Oct 2014 07:25:17 +0100
From: Thomas Graf <tgraf@suug.ch>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
Message-ID: <20141017062517.GA11584@casper.infradead.org>
References: <20141017002132.GA29584@sesse.net>
 <20141017003430.GB29584@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017003430.GB29584@sesse.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/14 at 02:34am, Steinar H. Gunderson wrote:
> On Fri, Oct 17, 2014 at 02:21:32AM +0200, Steinar H. Gunderson wrote:
> > Hi,
> > 
> > We recently upgraded a machine from 3.14.5 to 3.17.1, and a Perl script we're
> > running to poll SNMP suddenly needed ten times as much time to complete.
> 
> e341694e3eb57fcda9f1adc7bfea42fe080d8d7a looks like it might cause something
> like this (it certainly added the synchronize_net() call). Cc-ing people on 
> that commit; quoting the entire rest of the message for reference.

I think the only option at this point is to re-add the nltable lock to
netlink_lookup() so we can drop the synchronize_net() until we find a
way to RCUify socket destruction. I will cook up a patch today unless
somebody can come up with a smarter way to work around needing the
synchronize_net().
