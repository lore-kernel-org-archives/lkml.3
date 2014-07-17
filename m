Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaGQReo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:34:44 -0400
Received: from imap.thunk.org ([74.207.234.97]:41429 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaGQRen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:34:43 -0400
Date: Thu, 17 Jul 2014 13:34:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Bob Beck <beck@openbsd.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-abi <linux-abi@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717173433.GQ1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Bob Beck <beck@openbsd.org>, Christoph Hellwig <hch@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-abi <linux-abi@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
 <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:05:01AM -0600, Bob Beck wrote:
> Hi Ted, yeah I understand the reasoning, it would be good if there was
> a way to influence the various libc people to
> ensure they manage to provide a getentropy().

I don't anticipate that to be a problem.  And before they do, and/or
if you are dealing with a system where the kernel has been upgraded,
but not libc, you have your choice of either sticking with the
binary_sysctl approach, or calling getrandom directly using the
syscall method; and in that case, whether we use getrandom() or
provide an exact getentropy() replacement system call isn't that much
difference, since you'd have to have Linux-specific workaround code
anyway....

				- Ted
