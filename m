Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777Ab3IDPI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:08:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab3IDPI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:08:57 -0400
Date: Wed, 4 Sep 2013 17:08:54 +0200
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
Message-ID: <20130904150854.GF3996@quack.suse.cz>
References: <cover.1377193658.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-08-13 17:03:16, Andy Lutomirski wrote:
> Writes via mmap currently update mtime and ctime in ->page_mkwrite.
> This hurts both throughput and latency.  In workloads that dirty a
> large number of mmapped pages, ->page_mkwrite can be hot and
> file_update_time is slow and scales poorly.  Updating timestamps can
> also sleep, which hurts latency for real-time workloads.
  It would help to make your case if you posted the latency comparison
before & after the patchset in this introductory email. We can then see
how significant is the reduction of latency...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
