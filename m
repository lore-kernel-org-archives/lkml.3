Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbaFSSMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:12:08 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37919 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467AbaFSSMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:12:06 -0400
Date: Thu, 19 Jun 2014 11:12:01 -0700
From: josh@joshtriplett.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bug: Fix CONFIG_BUG=n BUG_ON()
Message-ID: <20140619181201.GA15963@cloud>
References: <53A2E573.6080407@acm.org>
 <5061693.b4BPIj9quA@wuerfel>
 <20140619172142.GA15696@cloud>
 <53A3232E.4080601@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A3232E.4080601@acm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 07:51:42PM +0200, Bart Van Assche wrote:
> On 06/19/14 19:21, josh@joshtriplett.org wrote:
> > That's exactly what BUG_ON becomes if CONFIG_BUG=y, and that
> > significantly increases kernel size; if you want that, set CONFIG_BUG=y.
> > BUG_ON should continue to compile to nothing if CONFIG_BUG=n, or
> > CONFIG_BUG=n has no reason to exist.
> 
> Hello Josh,
> 
> I wasn't aware that the current behavior of BUG_ON() with CONFIG_BUG=n
> was intentional. The reason I started looking into this is because
> different compiler warnings are generated for code with BUG_ON(1)
> statements when building against a kernel with CONFIG_BUG=y or
> CONFIG_BUG=n. There is an easy alternative though: changing BUG_ON(1)
> into BUG() in my code.

You should definitely never use BUG_ON(1); use BUG() if you want to say
"this (and the code after it) should never be reached".  That should
also avoid the compiler warnings.

If you encounter any compiler warnings caused by CONFIG_BUG=n that go
away with CONFIG_BUG=y, please do report them; those should get fixed.

- Josh Triplett
