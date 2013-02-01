Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422878Ab3BANOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:14:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:45482 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422847Ab3BANOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:14:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 64/89] x86, efi: Fix display detection in EFI boot stub
Date: Fri,  1 Feb 2013 14:08:19 +0100
Message-Id: <20130201130212.102429701@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

commit 70a479cbe80296d3113e65cc2f713a5101061daf upstream.

When booting under OVMF we have precisely one GOP device, and it
implements the ConOut protocol.

We break out of the loop when we look at it... and then promptly abort
because 'first_gop' never gets set. We should set first_gop *before*
breaking out of the loop. Yes, it doesn't really mean "first" any more,
but that doesn't matter. It's only a flag to indicate that a suitable
GOP was found.

In fact, we'd do just as well to initialise 'width' to zero in this
function, then just check *that* instead of first_gop. But I'll do the
minimal fix for now (and for stable@).

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1358513837.2397.247.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/eboot.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -316,10 +316,9 @@ static efi_status_t setup_gop(struct scr
 			 * Once we've found a GOP supporting ConOut,
 			 * don't bother looking any further.
 			 */
+			first_gop = gop;
 			if (conout_found)
 				break;
-
-			first_gop = gop;
 		}
 	}
 


