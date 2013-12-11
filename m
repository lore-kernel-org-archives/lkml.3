Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab3LKIFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:05:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36735 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKIFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:05:09 -0500
Date: Wed, 11 Dec 2013 08:05:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <antonio@meshcoding.com>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 2/3] batman-adv: Use seq_overflow
Message-ID: <20131211080504.GT10323@ZenIV.linux.org.uk>
References: <cover.1386738050.git.joe@perches.com>
 <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
 <20131211075526.GR10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211075526.GR10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 07:55:26AM +0000, Al Viro wrote:

> This sucker should return 0.  Insufficiently large buffer will be handled
> by caller, TYVM, if you give that caller a chance to do so.  Returning 1
> from ->show() is a bug in almost all cases, and definitely so in this one.
> 
> Just in case somebody decides that above is worth copying: It Is Not.
> Original code is buggy, plain and simple.  This one trades the older
> bug ("fail with -EINVAL whenever the buffer is too small") with just as buggy
> "silently skip an entry entirely whenever the buffer is too small".
> 
> Don't Do That.

Pardon - Joe has made seq_overflow return -1 instead of true.  Correction
to the above, then - s/This trades.*\./This is just as buggy./

Conclusion is still the same - Don't Do That.  Returning -1 on insufficiently
large buffer is a bug, plain and simple.

And this patch series is completely misguided - it doesn't fix any bugs
*and* it provides a misleading example for everyone.  See the reaction
right in this thread, proposing to spread the same bug to currently
working iterators.
