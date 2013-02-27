Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab3B0QoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:44:23 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50283 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab3B0QoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:44:22 -0500
Date: Wed, 27 Feb 2013 11:44:17 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: EXT4 corruption on Linus latest tree.
Message-ID: <20130227164417.GF5609@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20130227154311.GA12450@redhat.com>
 <20130227155539.GA2638@pd.tnic>
 <20130227160446.GA4792@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227160446.GA4792@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:04:46AM -0500, Dave Jones wrote:
>  > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> 
> Yeah, looks similar.  The missing files/dirs reappeared when I
> booted an older kernel, so it looks like the corruption doesn't
> hit the disk.  Fsck (1.42.5) didn't find anything either.

I suspect I see the problem...   can you send me the results of 

  debugfs -R "stat <172235804>" /dev/sdb1

to confirm?

Thanks,

						- Ted
