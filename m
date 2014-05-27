Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaE0JFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:05:45 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:54858 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaE0JFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:05:44 -0400
Date: Tue, 27 May 2014 11:05:27 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: cavium-octeon: remove checks for CONFIG_CAVIUM_GDB
Message-ID: <20140527090527.GG20055@linux-mips.org>
References: <1400602574.4912.43.camel@x220>
 <20140522132645.GC10287@linux-mips.org>
 <20140523213701.GD23153@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523213701.GD23153@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 11:37:01PM +0200, Andreas Herrmann wrote:

> > void __init smp_cpus_done(unsigned int max_cpus)
> > {
> > - 	mp_ops->cpus_done();
> > + 	if (cpus_done)
> > + 		mp_ops->cpus_done();
> > }
> > 
> > which would make a NULL cpus_done function pointer safe and allow empty definitions
> > to be removed.
> 
> I'd prefer this solution over complete removal of the hook.

In the end that's what I just did.

Which leaves smp_cpus_done() empty.  I think I'm going to put in a
function to print a summary of CPUs booted but that's for another
patch.

  Ralf
