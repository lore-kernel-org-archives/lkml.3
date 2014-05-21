Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaEUKi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:38:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaEUKi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:38:57 -0400
Date: Wed, 21 May 2014 12:38:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, thomas.mingarelli@hp.com
Subject: Re: [PATCH 5/6] x86, nmi: Move default external NMI handler to its
 own routine
Message-ID: <20140521103846.GA2485@laptop.programming.kicks-ass.net>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-6-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400181949-157170-6-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 03:25:48PM -0400, Don Zickus wrote:
> Now that we have setup an NMI subtye called NMI_EXT, there is really
> no need to hard code the default external NMI handler in the main
> nmi handler routine.
> 
> Move it to a proper function and register it on boot.  This change is
> just code movement.
> 
> In addition, update the hpwdt to allow it to unregister the default
> handler on its registration (and vice versa).  This allows the driver
> to take control of that io port (which it ultimately wanted to do
> originally), but in a cleaner way.

wanting that is one thing, but is it also a sane thing? You don't do
thing just because drivers want it.
