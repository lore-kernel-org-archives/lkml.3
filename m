Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaAWMMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:12:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:22186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaAWMMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:12:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,705,1384329600"; 
   d="scan'208";a="443427411"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: RE: [PATCH v5 00/22] Rewrite XIP code and add XIP support to ext4
Thread-Topic: [PATCH v5 00/22] Rewrite XIP code and add XIP support to ext4
Thread-Index: AQHPElnI8tI63XN3LkKqTLhJwMr9HJqSlNYA//+uZZc=
Date: Thu, 23 Jan 2014 12:12:43 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE04061DF33@FMSMSX114.amr.corp.intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>,<20140123090133.GR13997@dastard>
In-Reply-To: <20140123090133.GR13997@dastard>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.46]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you hitting the same problems with ext4 fsck that we did?  Version 1.42.8 reports spurious corruption.  From the 1.42.9 changelog:

  * Fixed a regression introduced in 1.42.8 which would cause e2fsck to
    erroneously report uninitialized extents past i_size to be invalid.

________________________________________
From: Dave Chinner [david@fromorbit.com]
Sent: January 23, 2014 1:01 AM
To: Wilcox, Matthew R
Cc: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-mm@kvack.org; linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 00/22] Rewrite XIP code and add XIP support to ext4

On Wed, Jan 15, 2014 at 08:24:18PM -0500, Matthew Wilcox wrote:
> This series of patches add support for XIP to ext4.  Unfortunately,
> it turns out to be necessary to rewrite the existing XIP support code
> first due to races that are unfixable in the current design.
>
> Since v4 of this patchset, I've improved the documentation, fixed a
> couple of warnings that a newer version of gcc emitted, and fixed a
> bug where we would read/write the wrong address for I/Os that were not
> aligned to PAGE_SIZE.
>
> I've dropped the PMD fault patch from this set since there are some
> places where we would need to split a PMD page and there's no way to do
> that right now.  In its place, I've added a patch which attempts to add
> support for unwritten extents.  I'm still in two minds about this; on the
> one hand, it's clearly a win for reads and writes.  On the other hand,
> it adds a lot of complexity, and it probably isn't a win for pagefaults.

I ran this through xfstests, but ext4 in default configuration fails
too many of the tests with filesystem corruption and other cascading
failures on the quick group tests (generic/013, generic/070,
generic/075, generic/091, etc)  for me to be able to tell if adding
MOUNT_OPTIONS="-o xip" adds any problems or not....

XIP definitely caused generic/001 to fail, but other than that I
can't really tell. Still, it looks like it functions enough to be
able to add XFS support on top of. I'll get back to you with that ;)

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
