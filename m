Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab3IDTnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:43:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56998 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab3IDTno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:43:44 -0400
Date: Wed, 4 Sep 2013 20:43:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
Message-ID: <20130904194341.GL13318@ZenIV.linux.org.uk>
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
 <20130904191104.GK13318@ZenIV.linux.org.uk>
 <52278AEC.2020307@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52278AEC.2020307@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 03:33:00PM -0400, Waiman Long wrote:

> I have thought about that. But if a d_move() is going on, the string
> in the buffer will be discarded as the sequence number will change.
> So whether or not it have embedded null byte shouldn't matter. That
> is why I didn't add code to do byte-by-byte copy at this first
> patch. I can add code to do that if you think it is safer to do so.

Sigh...  Junk in the output is not an issue; reading from invalid address
is, since you might not survive to the sequence number check.  Again,
if p is an address returned by kmalloc(size, ...), dereferencing p + offset
is not safe unless offset is less than size.
