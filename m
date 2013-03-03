Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3CCAXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 19:23:06 -0500
Received: from plane.gmane.org ([80.91.229.3]:46463 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3CCAXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 19:23:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ville Syrjala <syrjala@sci.fi>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume at 100%
Date: Sun, 3 Mar 2013 00:22:45 +0000 (UTC)
Message-ID: <loom.20130303T010825-770@post.gmane.org>
References: <50BDF345.60804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 188.238.108.1 (Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20100101 Firefox/17.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Oppedisano <roberto.oppedisano <at> gmail.com> writes:

> 
> Hello,
>      with recent kernels after a suspend/resume cycle on my laptop (HP 
> 6730b) the fans stays at full speed.

I too have been hit by this regression w/ a HP Compaq NC6000 laptop.

>From what I can tell 3.7.x gets confused about trip points after resume. Based
on the information in sysfs, it seems to always think that the CPU temp > 65C,
when in fact it's usually 40C or so. Loading the CPU enough to rise the
temperature past the trip point where the kernel thinks we're at seems to
re-synchronize the kernel's reality with the firmware's reality. On a few
occasions however the fan did stop, but the trip points were still confused the
same way. So what happened is that the fan didn't come back to life until I hit
the next higher trip point at 80C. Under normal conditions I've never reached
the 80C trip point on this laptop.

I also tried this tree:
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next
$ git describe
v3.8-rc2-72-gf5b6d45

Sadly I must report that it's even worse than 3.7. Even without any
suspend/resume cycles, the system gets confused. When I heat up the CPU the fan
comes on correctly and speeds up as the temperature rises. Unfortunately when
the temperature drops the fan doesn't slow down at all. So once I hit a high
trip point the fan stays at that speed forever.


