Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaEHIjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:39:04 -0400
Received: from plane.gmane.org ([80.91.229.3]:38799 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaEHIjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:39:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Vladimir Murzin <murzin.v@gmail.com>
Subject: Re: [PATCH] arm: memset: zero out upper bytes in r1
Date: Thu, 8 May 2014 08:38:46 +0000 (UTC)
Message-ID: <loom.20140508T103032-725@post.gmane.org>
References: <1399273875-8403-1-git-send-email-a.ryabinin@samsung.com> <loom.20140508T095105-952@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 217.140.96.21 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladimir Murzin <murzin.v <at> gmail.com> writes:

> 
> Andrey Ryabinin <a.ryabinin <at> samsung.com> writes:
> 
> > 
> > memset doesn't work right for following example:
> > 
> > 	signed char c = 0xF0;
> > 	memset(addr, c, size);
> > 
> > Variable c is signed, so after typcasting to int the value will be
0xFFFFFFF0.
> > This value will be passed through r1 regitster to memset function.
> > memset doesn't zero out upper bytes in r1, so memory will be filled
> > with 0xFFFFFFF0 instead of expected 0xF0F0F0F0.
> 
> It behaves the same as a generic implementation in lib/string.c, moreover
> gcc built-in behaves the same. So it looks like expected behavior and POSIX
> Programmer's Manual (man 3posix memset) explicitly says that "c" is
> converted to unsigned char.
> 
> Cheers
> Vladimir
> 
> 

Sorry, had a bad coffee when posted it ;) It behaves /different/, but it is
here for many years... doesn't this change break something? iow, it possible
that some user rely on this behavior...

Vladimir



