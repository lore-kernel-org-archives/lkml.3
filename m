Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab3GaWY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:24:57 -0400
Received: from imap.thunk.org ([74.207.234.97]:37601 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3GaWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:24:56 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2013 18:24:56 EDT
Date: Wed, 31 Jul 2013 18:01:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org,
        david@fromorbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130731220154.GA11378@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca,
	bpm@sgi.com, elder@kernel.org, hch@infradead.org,
	david@fromorbit.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you considered what happens if you have a 10 megabyte file, of
which the first 5 megs are mmap'ed into a userspace process.

Now suppose you call COLLAPASE_RANGE on a one megabyte range starting
at offset 1024k from the beginning of the file.

Does the right thing happen to the mmap'ed region in memory?

Cheers,

					- Ted
