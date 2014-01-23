Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaAWF7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:59:14 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62289 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaAWF7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:59:12 -0500
Date: Thu, 23 Jan 2014 09:59:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mel Gorman <mgorman@suse.de>, Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-ID: <20140123055906.GS1574@moon>
References: <20140122190816.GB4963@suse.de>
 <52E04A21.3050101@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E04A21.3050101@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 02:45:53PM -0800, Andy Lutomirski wrote:
> >     
> >     Thus when user space application track memory changes now it can detect if
> >     vma area is renewed.
> 
> Presumably some path is failing to set VM_SOFTDIRTY, thus preventing mms
> from being merged.
> 
> That being said, this could cause vma blowups for programs that are
> actually using this thing.

Hi Andy, indeed, this could happen. The easiest way is to ignore softdirty bit
when we're trying to merge vmas and set it one new merged. I think this should
be correct. Once I finish I'll send the patch.

	Cyrill
