Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3AZUXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:23:47 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:40692 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3AZUXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:23:45 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2013 15:23:44 EST
Date: Sat, 26 Jan 2013 22:15:41 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] mips: Move __virt_addr_valid() to a place for MIPS 64
Message-ID: <20130126201541.GF23053@blackmetal.musicnaut.iki.fi>
References: <1359137595.21576.246.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359137595.21576.246.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 25, 2013 at 01:13:15PM -0500, Steven Rostedt wrote:
> Commit d3ce88431892 "MIPS: Fix modpost error in modules attepting to use
> virt_addr_valid()" moved __virt_addr_valid() from a macro in a header
> file to a function in ioremap.c. But ioremap.c is only compiled for MIPS
> 32, and not for MIPS 64.
> 
> When compiling for my yeeloong2, which supposedly supports hibernation,
> which compiles kernel/power/snapshot.c which calls virt_addr_valid(), I
> got this error:

This has been reported also here:

	http://marc.info/?l=linux-mips&m=135788867604856&w=2

and here:

	http://marc.info/?l=linux-mips&m=135876719403187&w=2

It's pretty sad that MIPS has been pretty much broken during the whole
3.8-rc cycle. :-(

A.
