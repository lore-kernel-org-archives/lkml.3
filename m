Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3HEXKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:10:35 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46018 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3HEXKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:10:34 -0400
Date: Tue, 6 Aug 2013 01:10:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 08/16] x86, asmlinkage, kexec: Drop bogus asmlinkage in
 machine_kexec_32
Message-ID: <20130805231032.GQ19750@two.firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
 <1375740170-7446-9-git-send-email-andi@firstfloor.org>
 <52002F3F.9080407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52002F3F.9080407@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:03:27PM -0700, H. Peter Anvin wrote:
> On 08/05/2013 03:02 PM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > A function pointer cannot be asmlinkage. Just drop it.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Eh?  It certainly matters for the function pointer if it is regparm(0)
> or regparm(3), and the pointed-to function definitely assumes
> regparm(0).  So I think this patch is wrong, and if it isn't, it
> definitely needs better explanation why it isn't wrong.

Ok. Good point.

It causes compiler warnings with __attribute__((externally_visible))
because only a definition can be visible.

But yes it is needed for regparm.

So in a sense these two are incompatible. I guess it can be dropped
right now, as it's just a warning.

So please drop the patch and I'll too.
I'll not repost just for the drop, unless you ask me to 
(or other changes come up)

Longer term may need some different solution for this.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
