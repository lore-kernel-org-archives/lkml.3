Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534Ab3CNSCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:02:16 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53455 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab3CNSCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:02:14 -0400
Date: Thu, 14 Mar 2013 14:02:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Message-ID: <20130314180210.GA7784@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Josh Triplett <josh@joshtriplett.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
References: <20130313185911.GA1446@jtriplet-mobl1>
 <20130313190141.GF5604@thunk.org>
 <20130313191016.GA1793@jtriplet-mobl1>
 <20130314040835.GB11821@thunk.org>
 <20130314174216.GA2981@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314174216.GA2981@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:42:16AM -0700, Josh Triplett wrote:
> On Thu, Mar 14, 2013 at 12:08:35AM -0400, Theodore Ts'o wrote:
> > Huh.  This is very, very weird.  Is this a repeatable crash?
> 
> I could reliably replicate it for that particular session, but now that
> I've rebooted the host, no.

Well, I can tell you that from the stack trace, it looks like when the
file system was first being mounted, and the journal was being
replayed (which makes sense since you snapshotted a live file system),
when the journal inode was read in, it appeared to be corrupt.  While
trying to print an message declaring that the file system was corrupt
(via ext4_error()), we somehow dereferenced a NULL pointer.

I can't quite see how this could have happened; I can't understand how
the journal inode would have looked corrupt in the first place, and if
it was corrupt, how it could have triggered a NULL dereference.  So I
must be missing something....

						- Ted
