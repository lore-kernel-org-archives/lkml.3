Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3IZR4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:56:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:7955 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab3IZR4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:56:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,987,1371106800"; 
   d="scan'208";a="299743152"
Date: Thu, 26 Sep 2013 13:56:24 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Zuckerman, Boris" <borisz@hp.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        "rob.gittins@linux.intel.com" <rob.gittins@linux.intel.com>,
        "linux-pmfs@lists.infradead.org" <linux-pmfs@lists.infradead.org>,
        "linux-fsdevel@veger.org" <linux-fsdevel@veger.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
Message-ID: <20130926175624.GA7422@linux.intel.com>
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
 <522AB5AD.6070206@vlnb.net>
 <1379976688.5886.12.camel@Virt-Centos-6.lm.intel.com>
 <5243DB2A.7090609@vlnb.net>
 <4C30833E5CDF444D84D942543DF65BDA58066A30@G9W0739.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C30833E5CDF444D84D942543DF65BDA58066A30@G9W0739.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 02:56:17PM +0000, Zuckerman, Boris wrote:
> To work with persistent memory as efficiently as we can work with RAM we need a bit more than "commit". It's reasonable to expect that we get some additional support from CPUs that goes beyond mfence and mflush. That may include discovery, transactional support, etc. Encapsulating that in a special class sooner than later seams a right thing to do...

If it's something CPU-specific, then we wouldn't handle it as part of
the "class", we'd handle it as an architecture abstraction.  It's only
operations which are device-specific which would need to be exposed
through an operations vector.  For example, suppose you buy one device
from IBM and another device from HP, and plug them both into your SPARC
system.  The code you compile needs to run on SPARC, doing whatever
CPU operations are supported, but if HP and IBM have different ways of
handling a "commit" operation, we need that operation to be part of an
operations vector.
