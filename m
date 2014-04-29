Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbaD2Vsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:48:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46542 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaD2Vsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:48:46 -0400
Date: Tue, 29 Apr 2014 22:48:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140429214842.GL18016@ZenIV.linux.org.uk>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
 <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429211851.GA32204@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 07:18:51AM +1000, Dave Chinner wrote:

> Seems like it would work, but it seems fragile to me - I'm
> wondering how we can ensure that the private shrink list
> manipulations can be kept private.
> 
> We have a similar situation with the inode cache (private shrink
> list) but the I_FREEING flag is set the entire time the inode is on
> the shrink list. Any new hash lookup or attempt to grab the inode
> that occurs while I_FREEING is set fails, so perhaps dentries also
> need a well defined "being torn down and freed" state where new
> references cannot be taken even though the dentry can still be
> found...

Ummm...  You mean, have d_lookup() et.al. fail on something that is on
a shrink list?
