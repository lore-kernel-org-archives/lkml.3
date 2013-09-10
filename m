Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3IJA6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:58:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55359 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3IJA6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:58:00 -0400
Date: Tue, 10 Sep 2013 01:57:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: George Spelvin <linux@horizon.com>
Cc: torvalds@linux-foundation.org, aswin@hp.com, john@stoffel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        scott.norton@hp.com, Waiman.Long@hp.com
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130910005754.GV13318@ZenIV.linux.org.uk>
References: <20130909182111.GQ13318@ZenIV.linux.org.uk>
 <20130910004020.29299.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910004020.29299.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 08:40:20PM -0400, George Spelvin wrote:
> I'm really wondering about only trying once before taking the write lock.
> Yes, using the lsbit is a cute hack, but are we using it for its cuteness
> rather than its effectiveness?
> 
> Renames happen occasionally.  If that causes all the current pathname
> translations to fall back to the write lock, that is fairly heavy.
> Worse, all of those translations will (unnecessarily) bump the write
> seqcount, triggering *other* translations to fail back to the write-lock
> path.

_What_ "pathname translations"?  Pathname resolution doesn't fall back to
seq_writelock() at all.
