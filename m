Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbaD2R45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:56:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46336 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478AbaD2R44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:56:56 -0400
Date: Tue, 29 Apr 2014 18:56:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: dcache shrink list corruption?
Message-ID: <20140429175654.GI18016@ZenIV.linux.org.uk>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 06:01:39PM +0200, Miklos Szeredi wrote:

> Attached patch is just a starting point (untested).  Not sure how to minimize
> contention without adding too much complexity.

Contention isn't the worst problem here - I'd expect the cacheline ping-pong
to hurt more...  I agree with the analysis, but I'd really like to avoid that
spinlock ;-/

Let me see if we can avoid that...  Oh, well - at least that's a good excuse
to take a break from fucking deadlock analysis around the damn acct(2), most
of VFS and network filesystems ;-/
