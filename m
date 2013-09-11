Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3IKSko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:40:44 -0400
Received: from fieldses.org ([174.143.236.118]:46676 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab3IKSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:40:42 -0400
Date: Wed, 11 Sep 2013 14:40:38 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 1/2] seqlock: Add a new blocking reader type
Message-ID: <20130911184038.GD29749@fieldses.org>
References: <1378909707-3347-1-git-send-email-Waiman.Long@hp.com>
 <20130911145536.GJ13318@ZenIV.linux.org.uk>
 <52309B5F.70406@hp.com>
 <20130911172624.GK13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911172624.GK13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 06:26:25PM +0100, Al Viro wrote:
> On Wed, Sep 11, 2013 at 12:33:35PM -0400, Waiman Long wrote:
> 
> > >Folks, any suggestions on better names?  The semantics we are getting is
> > 
> > I will welcome any better name suggestion and will incorporate that
> > in the patch.
> 
> FWIW, the suggestions I've seen so far had been
> 
> seq_exreadlock() [ex for exclusive]
> seq_exclreadlock() [ditto, and IMO fails the "easily read over the phone"
> test - /sekv-excre...ARRGH/]
> seq_prot_readlock() [prot for protected, as in DLM protected read]

Though the DLM protected read doesn't self-conflict either so that's a
poor analogy, my bad.

(Do the users really require that the read be exclusive?)

--b.
