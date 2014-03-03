Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaCCTnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:43:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaCCTnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:43:40 -0500
Date: Mon, 3 Mar 2014 14:43:27 -0500
From: Dave Jones <davej@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] affs: AFFS_NO_TRUNCATE added to Kconfig
Message-ID: <20140303194327.GA22359@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>
References: <20140303182218.bc1de22e2c404dd1e07553b4@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303182218.bc1de22e2c404dd1e07553b4@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 06:22:18PM +0800, Fabian Frederick wrote:
 > Filename truncate process is defined in affs.h.
 > 
 > This patch exports current define to Kconfig and removes
 > AFFS_MAX_PREALLOC which is never used.
 > +
 > +config AFFS_NO_TRUNCATE
 > +	bool "Amiga FFS no filename truncate"
 > +	depends on AFFS_FS
 > +	default n
 > +	help
 > +	  If you say Y here, creating filesystem objects with longer names than
 > +	  30 characters (standard limit) will result in an error (ENAMETOOLONG).
 > +
 > +	  By default this option is disabled and filenames are automatically
 > +	  truncated.

I get the feeling this would be better as a mount option than a config option.
Then again, the number of people still caring about AFFS is probably in
single digits these days, so I doubt anyone would complain if this was set
one way or the other in a distribution kernel.

	Dave

