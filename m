Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935898AbaH0VWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:22:25 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:38808
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146AbaH0VWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:22:23 -0400
Date: Wed, 27 Aug 2014 16:22:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        willy@linux.intel.com
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
In-Reply-To: <20140827130613.c8f6790093d279a447196f17@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1408271616070.17080@gentwo.org>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com> <20140827130613.c8f6790093d279a447196f17@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Andrew Morton wrote:

> Sat down to read all this but I'm finding it rather unwieldy - it's
> just a great blob of code.  Is there some overall
> what-it-does-and-how-it-does-it roadmap?

Matthew gave a talk about DAX at the kernel summit. Its a great feature
because this is another piece of the bare metal hardware technology that
is being improved by him.

> Some explanation of why one would use ext4 instead of, say,
> suitably-modified ramfs/tmpfs/rd/etc?

The NVDIMM contents survive reboot and therefore ramfs and friends wont
work with it.

> Performance testing results?

This is obviously avoiding kernel buffering and therefore decreasing
kernel overhead for non volatile memory. Avoids useless duplication of
data from the non volatile memory into regular ram and allows direct
access to non volatile memory from user space in a controlled fashion.

I think this should be a priority item.


