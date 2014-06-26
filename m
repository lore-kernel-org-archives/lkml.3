Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaFZBR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:17:58 -0400
Received: from imap.thunk.org ([74.207.234.97]:58615 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232AbaFZBR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:17:57 -0400
Date: Wed, 25 Jun 2014 21:17:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] FS/JBD:replace count*size kmalloc by kmalloc_array
Message-ID: <20140626011751.GA6826@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
References: <1403722146-19657-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403722146-19657-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 08:49:06PM +0200, Fabian Frederick wrote:
> kmalloc_array manages count*sizeof overflow.

Except in these call sites, overflow is impossible.

kmalloc_array() is useful when count is coming from an unvalidated
source.  But in this case, the count is either a fixed, hard-coded
value (256), or the size of n*count is *guaranteed* to be less than
the page size.

So this just adds some extra code which is pointless (assuming the
compiler isn't smart enough to optimize it out).

	       	     	       		   - Ted
