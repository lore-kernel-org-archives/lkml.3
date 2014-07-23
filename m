Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbaGWUzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:55:35 -0400
Received: from imap.thunk.org ([74.207.234.97]:53181 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225AbaGWUzP (ORCPT <rfc822;Linux-Kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:55:15 -0400
Date: Wed, 23 Jul 2014 16:55:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Howard Chu <hyc@symas.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: [PATCH v8 00/22] Support ext4 on NV-DIMMs
Message-ID: <20140723205507.GG6673@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Howard Chu <hyc@symas.com>,
	Matthew Wilcox <willy@linux.intel.com>,
	Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <00ad731b459e32ce965af8530bcd611a141e41b6.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723121025.GE10317@node.dhcp.inet.fi>
 <20140723135514.GB6754@linux.intel.com>
 <53CFC258.6050803@symas.com>
 <20140723143453.GE6754@linux.intel.com>
 <53CFD483.2010106@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CFD483.2010106@symas.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 08:28:03AM -0700, Howard Chu wrote:
> >Perhaps you misunderstand the problem.  There are many different kinds
> >of NV-DIMM out there today with different performance characteristics.
> >One that has been described to me has write times 1000x slower than read
> >times.  In that situation, you can't possibly "just use it as page cache";
> >you need to place the read-often; write-rarely files on that media.
> 
> Thanks for the clarification. Yes, I was assuming "NVDIMM" to mean something
> with DRAM performance + persistence, like http://www.agigatech.com/ddr3.php
> or http://www.vikingtechnology.com/nvdimm-technology . That's also the
> definition in Wikipedia http://en.wikipedia.org/wiki/NVDIMM

One example might be PCM (Phase Change Memory).  PCM has read speeds
comporable to RAM or NOR flash, so you can certainly execute out of
PCM.  However, writes generally tend to be bottlenecked on power
(since you need to effectively melt the PCM cell to cause it change
from crystalline to amorphous state and vice versa).

This year's FAST conference quoted a commericially available
SATA-attached PCM device that was 16x times faster than MLC SSD for 4k
reads, but 3.4x times slower than MLC SSD for 4k writes, and it was
basically limited to how much power/heat could fed/removed in/out of
the PCM chip.  See:
https://www.usenix.org/conference/fast14/technical-sessions/presentation/kim
starting at about 2:00 to 10:30.

Cheers,

						- Ted
