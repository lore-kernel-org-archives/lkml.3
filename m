Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3EKVGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:06:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39232 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3EKVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:06:43 -0400
Date: Sat, 11 May 2013 22:06:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] next cycle fun: ->release() API change
Message-ID: <20130511210641.GQ25399@ZenIV.linux.org.uk>
References: <20130509050343.GD25399@ZenIV.linux.org.uk>
 <CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
 <20130511172242.GP25399@ZenIV.linux.org.uk>
 <CA+55aFzsgr6ZHWxNRvM3VZu=bWn75TfGb0EAXO1wdFnBFTCz-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzsgr6ZHWxNRvM3VZu=bWn75TfGb0EAXO1wdFnBFTCz-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 12:16:22PM -0700, Linus Torvalds wrote:

> >> Because renaming really doesn't buy us anything but pain.
> >
> > Umm...  I'd rather go the whole way and get rid of inode argument as well,
> > while we are at it.  It's completely redundant and it's unused in very large
> > majority of the instances.
> 
> So? What's the advantage of removing it?

Less boilerplate?  We used to pass inode to fput() as well, but
switched to passing file alone...  Put it that way - if you were adding
such method today, would you bother with passing an argument that is
unused by most of the instances and can be trivially obtained from the
argument we have to pass?  Sure, back then you had the opposite
situation - all non-empty instances were using inode (and none of them
even looked at file), but with the mix we have these days...
Hell knows; I agree that if we really try to preserve the interface
compatibility here, just switching the return type wins, but since
the conversion for every particular driver is trivial anyway...

> Also, "->close()" would be *exactly* the wrong name to call this,
> since it would be absolutely and utterly misleading. "->release()" is
> _not_ about close, and in fact the whole return code is partially due
> to people thinking it is. It's "->flush()" that gets called at close
> time.

Agreed - I'd welcome any alternative suggestions, and yes, I understand your
point re "just call it 'release'".
