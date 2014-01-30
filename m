Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaA3Hy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 02:54:28 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaA3Hy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 02:54:26 -0500
Date: Wed, 29 Jan 2014 23:54:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140130075421.GA10050@infradead.org>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
 <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 11:09:18AM -0800, Linus Torvalds wrote:
> So attached is the incremental diff of the patch by Sage and Ilya, and
> I'll apply it (delayed a bit to see if I can get the sign-off from
> Ilya), but I also think we should fix the (non-cached) ACL functions
> that call down to the filesystem layer to also get the dentry.

For ->set_acl that's fairly easily doable and I actually had a version
doing that to be able to convert 9p.  But for ->get_acl the path walking
caller didn't seem easily feasible.  ->get_acl actually is an invention
of yours, so if you got a good idea to get the dentry to it I'd love
to be able to pass it.

