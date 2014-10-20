Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaJTXtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaJTXtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:49:12 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: linux-audit@redhat.com
Cc: Paul Moore <pmoore@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/5] audit by executable name
Date: Mon, 20 Oct 2014 19:49:12 -0400
Message-ID: <13863680.WTabxyvHIP@x2>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.16.6-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <4185398.VpQETdPFDe@x2>
References: <cover.1412303728.git.rgb@redhat.com> <2652562.S2IH3gqS0u@sifl> <4185398.VpQETdPFDe@x2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2014 07:33:39 PM Steve Grubb wrote:
> On Monday, October 20, 2014 07:02:33 PM Paul Moore wrote:
> > On Monday, October 20, 2014 06:47:27 PM Eric Paris wrote:
> > > On Mon, 2014-10-20 at 16:25 -0400, Steve Grubb wrote:
> > > > On Thursday, October 02, 2014 11:06:51 PM Richard Guy Briggs wrote:
> > > > > This is a part of Peter Moody, my and Eric Paris' work to implement
> > > > > audit by executable name.
> > > > 
> > > > Does this patch set define an AUDIT_VERSION_SOMETHING and then set
> > > > AUDIT_VERSION_LATEST to it? If not, I need one to tell if the kernel
> > > > supports it when issuing commands. Also, if its conceivable that
> > > > kernels
> > > > may pick and choose what features could be backported to a curated
> > > > kernel, should AUDIT_VERSION_ be a number that is incremented or a bit
> > > > mask?
> > > 
> > > Right now the value is 2. So this is your last hope if you want to make
> > > it a bitmask. I'll leave that up to paul/richard to (over) design.
> > 
> > Audit is nothing if not over-designed.  I want to make sure we're
> > consistent with the previous design methodologies ;)
> > 
> > I've been thinking about this for about the past half-hour while I've been
> > going through some other mail and I'm not really enthused about using the
> > version number to encode capabilities.  What sort of problems would we
> > have
> > if we introduced a new audit netlink command to query the kernel for audit
> > capabilities?
> 
> I thought that is what we were getting in this patch:
> https://www.redhat.com/archives/linux-audit/2014-January/msg00054.html
> 
> As I understood it, I send an AUDIT_GET command on netlink and then look in
> status.version to see what we have. I really think that in the mainline
> kernel, there will be a steady increment of capabilities. However, for
> distributions, they may want to pick and choose which capabilities to
> backport to their shipping kernel. Meaning in practice, a bitmap may be
> better to allow cherry picking capabilities and user space being able to
> make informed decisions.
> 
> I really don't mind if this is done by a new netlink command (but if we do,
> what happens to status.version?) or if we just keep going with
> status.version. Just tell me which it is.

Further to the point of status.version, its declared as a __u32. So if it were 
a bit map, we can have 32 different features userspace needs to make support 
decisions on. I have a feeling that will last many years because I really 
can't see audit gaining too many more capabilities.

-Steve
