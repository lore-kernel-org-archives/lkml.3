Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab3EOAHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 20:07:23 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:12493 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758685Ab3EOAHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 20:07:21 -0400
Date: Wed, 15 May 2013 01:07:15 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        netdev@vger.kernel.org
Subject: r8169 on 3.8.13, 3.9.2, 3.10-rc1, was Re: [ 00/73] 3.8.13-stable
 review
Message-ID: <20130515000715.GA20099@milliways>
References: <20130509222757.917088509@linuxfoundation.org>
 <pan.2013.05.10.10.54.26.943195@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pan.2013.05.10.10.54.26.943195@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=wom5GMh1gUkA:10 a=DKufjtCz-h8A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=DfNHnWVPAAAA:8 a=WgTq_mZlXGbTuIDsb-AA:9 a=wPNLvfGTeEIA:10 a=lBRciGGoxdUA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:54:27PM +0200, Holger Hoffstaette wrote:

 Cc'ing to netdev because I don't think this has had a response, and
I care because I *might* be seeing the same problem on both 3.9.2
and 3.10-rc1, but my take on the problem is slightly different [
details after Holger's posting ]

> On Thu, 09 May 2013 15:31:23 -0700, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 3.8.13 release. There
> 
> This patchset broke my internet, with all sorts of weird effects like
> Samba clients having problems to talk to the server and only partially
> working DNS resolution (CDNs broken, Amazon unreachable).
> 
> After two reboots to/from .12/.13 (to rule out temporary internet
> brokenness) the problem has been identified as:
> 
> > Stefan Bader <stefan.bader@canonical.com>
> >     r8169: fix 8168evl frame padding.
> 
> After reverting only this patch (turning r8169 back to 3.8.12) things
> again behave as expected with the rest of .13. So far no other regressions
> detected.
> 
> This patch should probably be removed from 3.9.2-rc as well.
> 
> -h
> 
 For me, I'm seeing what might be a similar problem in about 2/5 of
my boots of 3.9.2 and 3.10-rc1 : in my case, r8169 is a module [ most
things are built in ], I use dhclient to get an ip address, and I
have separate nfs shares for /sources [ in /etc/mtab ] and my user's
~/notes [ mounted from ~/.bashrc ].

 On a good boot, everything mounts.  On a bad boot, /sources is NOT
mounted because eth0 is not up, but by the time anyone logs in it
_is_ up so mounting ~/notes [and manually mounting /sources as root]
works.  What seems to be happening is that eth0 is coming up
slightly later on some occasions (about 11 seconds from booting,
instead of 10.5 seconds) and somehow the dhclient script seems to
have ended *before* that.

 For me, this isn't bisectable (so far, 10 boots of 3.9.2 and
3.10-rc1 on this box, and 4 were problematic).  On this box, 3.9.0
itself was perfect.

Holger : apologies if I've hijacked this thread with what turns out
to be a different problem.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
