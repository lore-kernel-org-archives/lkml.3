Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbbAJA2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:28:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:6096 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbbAJA2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:28:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,734,1413270000"; 
   d="scan'208";a="667427267"
Subject: Re: [PATCH char-misc-next 02/13] misc: mic: SCIF ring buffer
 infrastructure
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>
In-Reply-To: <20150109230526.GB3614@kroah.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
	 <6a99cdd6459ca70802f0000c1904bfdb8f45b73b.1418237176.git.sudeep.dutt@intel.com>
	 <20150109230526.GB3614@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jan 2015 16:28:19 -0800
Message-ID: <1420849699.6393.33.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 15:05 -0800, Greg Kroah-Hartman wrote:
> On Wed, Dec 10, 2014 at 11:47:42AM -0800, Sudeep Dutt wrote:
> > SCIF ring buffer is a single producer, single consumer byte stream ring
> > buffer optimized for avoiding reads across the PCIe bus. The ring buffer is
> > used to implement a receive queue for SCIF driver messaging between nodes and
> > for byte stream messaging between SCIF endpoints. Each SCIF node has a
> > receive queue for every other SCIF node, and each connected endpoint has a
> > receive queue for messages from its peer. This pair of receive queues is
> > referred to as a SCIF queue pair.
> 
> And the reason you aren't using the built-in kernel ring buffer code is
> why?
> 

This simple byte stream ring buffer is in our performance data path for
small messages and is optimized to avoid reads across the PCIe bus while
adding the required barriers and hardware workarounds for the MIC
Coprocessor. I will add some more documentation here in the v2 which I
will post early next week. 

We did not find other ring buffers in the kernel which were tailored for
our use case across PCIe. I am guessing (please correct me) that you are
referring to the ring buffer in include/linux/ring_buffer.h. It does not
seem to be designed for being used between two independent OS's across
the PCIe bus. Please let me know your thoughts.

Thanks,
Sudeep Dutt


