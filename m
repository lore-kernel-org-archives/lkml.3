Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbbAZSIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:08:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:20042 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbbAZSIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:08:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,470,1418112000"; 
   d="scan'208";a="642768404"
Subject: Re: [PATCH char-misc-next v2 00/13] misc: mic: SCIF driver
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>
In-Reply-To: <20150125124429.GC21763@kroah.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
	 <20150125124429.GC21763@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jan 2015 10:07:07 -0800
Message-ID: <1422295627.9362.173.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-25 at 20:44 +0800, Greg Kroah-Hartman wrote:
> On Mon, Jan 12, 2015 at 03:09:54PM -0800, Sudeep Dutt wrote:
> > ChangeLog:
> > =========
> > v1 => v2:
> > a) Use kernel-doc formatting for SCIF header file documentation, enhance
> >    SCIF ring buffer documentation and formatting cleanup in patch 4 as
> >    per feedback from Greg Kroah-Hartman
> > b) SCIF bug fixes and cleanups since initial post
> > 
> > v1: Initial post @ https://lkml.org/lkml/2014/12/10/546
> 
> Do you have any test code that can be added to the tree to exercise this
> api and at least give a hint as to how it all works from the userspace
> side?  You don't have any pointers to any userspace code, what is using
> this API?
> 

SCIF has been used to implement an ICC offload compiler runtime in user
space. We will be submitting a kernel client as well if this initial
patch series is accepted upstream. SCIF has a user space library which
is a thin IOCTL wrapper providing a user space API similar to the kernel
API in scif.h. The SCIF user space library is distributed separately via
https://software.intel.com/en-us/mic-developer

Here is some SCIF pseudo code as an example:

Process A (on host)	 		Process B (on MIC Coprocessor)

scif_open(..)				scif_open(..)
scif_bind(..)				scif_bind(..)
scif_listen(..)
scif_accept(..)				scif_connect(..)
/* SCIF connection established */

/* Send and receive control messages */
scif_send(..)/scif_recv(..)		scif_send(..)/scif_recv(..)

/* Register memory */
scif_register(..)			scif_register(..)

/* RDMA */
scif_readfrom(..)/scif_writeto(..)    scif_readfrom(..)/scif_writeto(..)

mmap(..)				mmap(..)
/* Access remote registered memory */

/* Close the endpoints */
scif_close(..)				scif_close(..)

The user space code has been distributed and maintained separately from
the kernel so we did not include it as part of this patch series to
avoid bloating the kernel. Do you think we should include the user space
SCIF library and some sample user space test applications under
Documentation/mic with this patch series?

Thanks,
Sudeep Dutt

