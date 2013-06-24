Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3FXDMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 23:12:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60607 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab3FXDMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 23:12:44 -0400
Date: Sun, 23 Jun 2013 23:12:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <esandeen@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        Namjae Jeon <linkinjeon@gmail.com>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "a.sangwan@samsung.com" <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Message-ID: <20130624031235.GA6991@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Namjae Jeon <linkinjeon@gmail.com>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
 <20130624024459.GJ29376@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624024459.GJ29376@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 12:44:59PM +1000, Dave Chinner wrote:
> 
> Hence, at minimum, this should be a fallocate() operation, not a ext4
> specific ioctl as it is relatively trivial to implement on most
> extent based filesystems.

The fallocate() uses a units of bytes for the offset and length; would
a FALLOC_FL_COLLAPSE_RANGE be guaranteed to work on any arbitrary
offset and length?  Or would it only work if the offset and length are
multiples of the file system blocksize?

The the EXT4_IOC_TRUNCATE_BLOCK_RANGE interface solves this problem by
using units of file system blocks (i.e., __u32 start_block), but that
raises another issue, which is it forces the user space program to
somehow figure out the file system block size, which seems a bit nasty.

	       	       	    	   	       - Ted
