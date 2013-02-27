Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab3B0TEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:04:44 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:50341 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab3B0TEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:04:30 -0500
Date: Wed, 27 Feb 2013 14:04:19 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "gnehzuil.liu" <gnehzuil.liu@gmail.com>,
        Zheng Liu <wenqing.lz@taobao.com>, Borislav Petkov <bp@alien8.de>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Message-ID: <20130227190419.GB19624@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>, Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20130227153435.GB5609@thunk.org>
 <20130227154450.GA23402@x4>
 <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185755.GA17786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227185755.GA17786@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 01:57:55PM -0500, Dave Jones wrote:
> Building now.  Can you confirm that nothing on-disk should be awry ?
> Or will I need a new fsck to detect what happened ?
> 

Well, it's possible that a read from data file which had blocks
located above 512GB might have gotten bogus information, or a block
allocated above 512GB might result in a write to the wrong place on
disk.

So if you are very cautious, running fsck just to make sure things are
OK is not a bad idea.  But it's likely that the directory sanity
checks would have caught things quickly, or trying run an executable
would have caused a seg fault quickly enough.  If your system crashed
very quickly during the boot process, you'll probably be OK.

       	      	      	   	      	  - Ted
