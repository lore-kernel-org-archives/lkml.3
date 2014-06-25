Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbaFYQXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:23:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:46170 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbaFYQX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:23:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,546,1400050800"; 
   d="scan'208";a="553184710"
Date: Thu, 26 Jun 2014 00:23:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@lst.de>, Micky Ching <micky_ching@realsil.com.cn>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [hch-scsi-queue:core-for-3.17 18/27]
 drivers/staging/rts5208/rtsx.c:468:5: warning: format '%d' expects argument
 of type 'int', but argument 4 has type 'u64'
Message-ID: <20140625162322.GA8121@localhost>
References: <53aaebe2.SHsdePtLmXw5IHwp%fengguang.wu@intel.com>
 <20140625154140.GA16179@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625154140.GA16179@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, Jun 25, 2014 at 05:41:40PM +0200, Christoph Hellwig wrote:
> Fengguang,
> 
> can you change the kbuild robot to only send warnings in the staging
> drivers to the maintainers of those, and not people changing core code?

The rule is currently CC the first bad commit's author and committer.
In this case,

        commit 4184a1e415257e3d2e75a5adf184de9ffaf82a7c
        Author:     Hannes Reinecke <hare@suse.de>
        AuthorDate: Wed Jun 25 15:27:36 2014 +0200
        Commit:     Christoph Hellwig <hch@lst.de>
        CommitDate: Wed Jun 25 16:21:45 2014 +0200

            scsi: use 64-bit LUNs

=>

        TO: Hannes Reinecke <hare@suse.de>
        CC: Christoph Hellwig <hch@lst.de>

Do you mean adding rule

        if error_file =~ /drivers\/staging/
                TO/CC error_file's author/committer instead
        end

In this case,

        TO: Micky Ching <micky_ching@realsil.com.cn>
        CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I agree that it'd be good for Micky to work out a fix for his staging
driver. However due to the obvious dependency here, it looks best for
you to include the fix together with "scsi: use 64-bit LUNs"?

So in general it'd be good to keep all relevant people in the CC list.
That is,

        TO/CC first bad commit's author/committer
        for each error_file =~ /drivers\/staging/
                CC error_file's author/committer
        end

Thanks,
Fengguang
