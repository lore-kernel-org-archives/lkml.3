Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaAWGGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:06:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaAWGGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:06:10 -0500
Date: Wed, 22 Jan 2014 22:09:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Mel Gorman <mgorman@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-Id: <20140122220910.198121ee.akpm@linux-foundation.org>
In-Reply-To: <20140123055906.GS1574@moon>
References: <20140122190816.GB4963@suse.de>
	<52E04A21.3050101@mit.edu>
	<20140123055906.GS1574@moon>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 09:59:06 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Wed, Jan 22, 2014 at 02:45:53PM -0800, Andy Lutomirski wrote:
> > >     
> > >     Thus when user space application track memory changes now it can detect if
> > >     vma area is renewed.
> > 
> > Presumably some path is failing to set VM_SOFTDIRTY, thus preventing mms
> > from being merged.
> > 
> > That being said, this could cause vma blowups for programs that are
> > actually using this thing.
> 
> Hi Andy, indeed, this could happen. The easiest way is to ignore softdirty bit
> when we're trying to merge vmas and set it one new merged. I think this should
> be correct. Once I finish I'll send the patch.

Hang on.  We think the problem is that gimp is generating vmas which
*should* be merged, but for unknown reasons they differ in
VM_SOFTDIRTY, yes?

Shouldn't we work out where we're forgetting to set VM_SOFTDIRTY? 
Putting bandaids over this error when we come to trying to merge the
vmas sounds very wrong?
