Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaIXUST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:18:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40718 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIXUSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:18:17 -0400
Date: Wed, 24 Sep 2014 21:18:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140924201813.GI7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
 <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:20:38PM -0700, Linus Torvalds wrote:
> On Wed, Sep 24, 2014 at 11:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Yecchhhh...  Applied, but it's very ugly.  Oh, well - regression is
> > regression, and I don't see a cleaner fix at the moment.  If I don't
> > manage to come up with anything prettier, to Linus it goes in tonight
> > pull request ;-/
> 
> Please don't. That thing is too ugly to exist. It also looks
> completely and utterly buggy. There's no way I'm taking it. If
> switch-names is suddenly conditional, what the f*ck happens to the
> name hash which is unconditionally done with a swap() right
> afterwards.

The sucker's unhashed after that...  And yes, I agree that it's fucking
ugly.  Still looking for saner ways to do that...
