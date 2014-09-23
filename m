Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbaIWXAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:00:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:62403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbaIWXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:00:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,583,1406617200"; 
   d="scan'208";a="607453448"
From: ashutosh dixit <ashutosh.dixit@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Foley <pefoley2@pefoley.com>,
        "Dutt\, Sudeep" <sudeep.dutt@intel.com>,
        "Rao\, Nikhil" <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd builds for kernels < 3.13
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
	<5421EA22.6000206@infradead.org>
Date: Tue, 23 Sep 2014 15:59:51 -0700
In-Reply-To: <5421EA22.6000206@infradead.org> (Randy Dunlap's message of "Tue,
	23 Sep 2014 15:46:10 -0600")
Message-ID: <ndhwbqvboe9c48.fsf@rasscmlmus001.pdx.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23 2014 at 02:46:10 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 09/23/14 14:55, Ashutosh Dixit wrote:
>> mpssd depends on headers available in kernels >= 3.13. Therefore
>> disable the build for kernels < 3.13. For kernels < 3.13, to avoid the
>> appearance of a build break simply print an error message and exit.
>
> Why is this needed?  This file won't be built in any automated build
> in v3.13 or any kernel until v3.17 at the earliest?
>
Correct, if things in Documentation will be compiled against the headers
in the kernel source tree then this patch is not required. However,
Andrew had reported the following compile error:

> In file included from Documentation/mic/mpssd/sysfs.c:21:
> Documentation/mic/mpssd/mpssd.h:55:30: error: linux/virtio_ids.h: No such file or directory

which made it appear to us that Documentation was being compiled against
headers installed on the system, not headers in the kernel source
tree. The patch was submitted to address this latter case, but if that
does not occur it is not required.

