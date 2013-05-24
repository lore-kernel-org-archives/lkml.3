Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab3EXKE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:04:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37860
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759561Ab3EXKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:04:56 -0400
Date: Fri, 24 May 2013 06:04:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Karel Zak <kzak@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130524100452.GA15570@infradead.org>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be>
 <1367270313-18871-3-git-send-email-phdm@macqel.be>
 <20130520163927.8e4c2fe753b60a02c368ceb5@linux-foundation.org>
 <20130521072754.GB19266@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521072754.GB19266@frolo.macqel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 09:27:54AM +0200, Philippe De Muyter wrote:
> AIX LVM permits to make "logical volumes" which are made of multiple slices
> of multiple disks.  The new code allows only access to the "logical volumes"
> which are made of one slice on the probed disk, a slice being a contiguous
> disk area.  The code also detects "logical volumes" made of multiple slices
> on the probed disk, but can not describe them to the partition layer, because
> the partition layer generic code does not support that.  When such
> non-contiguous "logical volumes" are detected, a diagnostic message is
> printed.

This very much screams like it should be implemented in the lvm2
userspace package using the dm kernel driver.

