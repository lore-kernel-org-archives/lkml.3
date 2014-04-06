Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaDFAFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 20:05:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:43441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbaDFAFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 20:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,802,1389772800"; 
   d="scan'208";a="507710721"
Date: Sat, 5 Apr 2014 17:05:12 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modpost: Fix ressource leak in read_dump()
Message-ID: <20140406000512.GS32556@tassilo.jf.intel.com>
References: <20140406003649.1ba3c993@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406003649.1ba3c993@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 12:36:49AM +0200, Christian Engelmayer wrote:
> Function read_dump() memory maps the input via grab_file(), but fails to call
> the corresponding unmap function. Add the missing call to release_file().
> Detected by Coverity: CID 1192419

It doesn't matter at all. All memory is freed on exit() in this program.

-Andi
