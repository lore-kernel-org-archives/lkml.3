Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaEOCSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:18:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:40760 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaEOCSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:18:01 -0400
Date: Wed, 14 May 2014 22:17:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515021749.GA3123@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
	Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
	Eric Sandeen <esandeen@redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <20140514215457.GC5421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514215457.GC5421@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 07:54:57AM +1000, Dave Chinner wrote:
> On Tue, May 13, 2014 at 08:31:02PM +0200, Mateusz Guzik wrote:
> > This helps hang troubleshooting efforts when only dmesg is available.
> 
> I really don't think that spamming dmesg every time a filesystem is
> frozen or thawed is a good idea. This happens a *lot* when systems
> are using snapshots, and for the most part nobody cares about
> freeze/thaw cycles because they almost always work just fine.

The problems people are worried about are when there is freezing and
unfreezing taking place in combination with a machine-level
suspend/resume cycle, no?  What if we only spammed dmesg when doing a
suspend/resume?

						- Ted
