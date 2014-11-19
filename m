Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaKSUUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:20:03 -0500
Received: from plane.gmane.org ([80.91.229.3]:40728 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbaKSUUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:20:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Date: Wed, 19 Nov 2014 20:19:40 +0000 (UTC)
Message-ID: <pan.2014.11.19.20.19.40@googlemail.com>
References: <20141013022454.289398272@linuxfoundation.org>
	<20141013112834.GA10826@khazad-dum.debian.net>
	<20141013082319.175d90bb@as> <20141119172235.GA31260@kroah.com>
	<20141119194414.GN5050@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4ff589a3.dip0.t-ipconnect.de
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 11:44:14 -0800, Paul E. McKenney wrote:

> On Wed, Nov 19, 2014 at 09:22:35AM -0800, Greg Kroah-Hartman wrote:
>> 
>> Doesn't build in 3.17 properly :(
> 
> Older kernels can use rcu_note_context_switch() instead of
> rcu_note_voluntary_context_switch(), which didn't show up until quite
> recently.  Please note that rcu_note_context_switch() is quite a bit
> more heavy-weight than is rcu_note_voluntary_context_switch(), but it
> should be OK in this context.

When I tried this in 3.14.x the kernel would lock up immediately during
boot (not even a console). This may or may not have to do with me also
using the BFS scheduler, but it's IMHO something that should be
double-checked.

I also tried to backport the necessary macros but that went nowhere
fast, since they ended up pulling in most of the rcu-task stuff..

-h

