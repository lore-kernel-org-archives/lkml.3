Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3EKRWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 13:22:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3EKRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 13:22:44 -0400
Date: Sat, 11 May 2013 18:22:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] next cycle fun: ->release() API change
Message-ID: <20130511172242.GP25399@ZenIV.linux.org.uk>
References: <20130509050343.GD25399@ZenIV.linux.org.uk>
 <CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 10:05:05AM -0700, Linus Torvalds wrote:

> Ugh. You know what? I'd almost prefer to just do it as a single big
> commit, *without* the extra churn of then also renaming things.
> Because the renaming will just be painful and result in *more*
> problems, and quite frankly, this particular ABI change is "benign" in
> the sense that unconverted drivers will just cause warnings - the code
> will still compile (module -Werror, of course, which some
> architectures use) and still work perfectly fine (modulo crazy C paper
> standard issues that have nothing to do with actual reality).
> 
> In fact, the "it still works fine, just complains" makes it perfecly
> reasonable to even split it up into multiple independent commits. So
> rather than do the stupid renaming, I'd be perfectly happy with one
> commit that just changes "int ("release)(..)" to "void (*release)(..)"
> and then a boatload of "remove return value from release in
> drivers/block/*" kind of commits that do the conversion.
> 
> Because renaming really doesn't buy us anything but pain.

Umm...  I'd rather go the whole way and get rid of inode argument as well,
while we are at it.  It's completely redundant and it's unused in very large
majority of the instances.
