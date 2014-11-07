Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaKGKAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:00:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaKGKAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:00:13 -0500
Date: Fri, 7 Nov 2014 10:23:13 +0100
From: Karel Zak <kzak@redhat.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/5] brd: Add getgeo to block ops for fdisk
Message-ID: <20141107092313.GH6880@x2.net.home>
References: <545A2D69.8090003@plexistor.com>
 <545A2FEA.3050101@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545A2FEA.3050101@plexistor.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:10:50PM +0200, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> Now when fdisk is run on brd it will ask some cryptic
> questions about CHS. This is because the getgeo block operation
> is not implemented.

 Again, what fdisk (util-linux) version?

> I have done a quick audit of the fdisk code. The CHS calculation
> is very convoluted but at the end it comes out with a number.
> Which is taken into consideration in first-sector to allow. With
> all 1(s) this numbers is very small and other numbers come into
> account. Also note that if the device is big like 1G (not sure what
> is the threshold) fdisk will offer 1M (2048) as possible first-
> sector, and it does not matter what numbers we give here.

 oh.. sounds like archeology, CHS calculation does not mater in the
 current code, it follows I/O limits (including crazy alignment
 offset).

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
