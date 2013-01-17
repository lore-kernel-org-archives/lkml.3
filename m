Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab3AQUCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:02:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3AQUCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:02:22 -0500
Date: Thu, 17 Jan 2013 18:02:14 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ 24/71] ring-buffer: Fix race between integrity check and
 readers
Message-ID: <20130117200213.GC2872@herton-Z68MA-D2H-B3>
References: <20130115225340.367496998@linuxfoundation.org>
 <20130115225342.176297340@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115225342.176297340@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 02:54:21PM -0800, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Steven Rostedt <srostedt@redhat.com>
> 
> commit 9366c1ba13fbc41bdb57702e75ca4382f209c82f upstream.
> 
> The function rb_check_pages() was added to make sure the ring buffer's
> pages were sane. This check is done when the ring buffer size is modified
> as well as when the iterator is released (closing the "trace" file),
> as that was considered a non fast path and a good place to do a sanity
> check.
> 
> The problem is that the check does not have any locks around it.
> If one process were to read the trace file, and another were to read
> the raw binary file, the check could happen while the reader is reading
> the file.
> 
> The issues with this is that the check requires to clear the HEAD page
> before doing the full check and it restores it afterward. But readers
> require the HEAD page to exist before it can read the buffer, otherwise
> it gives a nasty warning and disables the buffer.
> 
> By adding the reader lock around the check, this keeps the race from
> happening.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Too late now (and harmless), but the commit id and changelog are wrong, the
real commit for this backport is 54f7be5b831254199522523ccab4c3d954bbf576
(ring-buffer: Fix NULL pointer if rb_set_head_page() fails). The same
happened with the patch applied on 3.4 this cycle.

-- 
[]'s
Herton
