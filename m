Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaLGIEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 03:04:44 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64312 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaLGIEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 03:04:41 -0500
Date: Sun, 7 Dec 2014 08:04:34 +0000
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 3/3] Drivers: hv: hv_balloon: Don't post pressure status
 from interrupt context
Message-ID: <20141207080433.GA4531@sucs.org>
References: <1417559331-13691-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417559355-13730-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 02:29:15PM -0800, K. Y. Srinivasan wrote:
> We currently release memory (balloon down) in the interrupt context and we also
> post memory status while releasing memory. Rather than posting the status
> in the interrupt context, wakeup the status posting thread to post the status.
> This will address the inconsistent lock state that Sitsofe Wheeler <sitsofe@gmail.com>
> reported:

Sorry I didn't follow up on this. Things looked better after the patch
but I was seeing a strange issue where the memory was being reduced to
some minimum and the balloon would never shrink so the available memory
was seemingly locked from then on. I ran out of time to investigate this
later behaviour and didn't have the time to check if it had always been
the case but I think I see other patches saying you nailed it and other
issues. Do you have a published git tree with all these pieces in or
have they already been mainlined?

-- 
Sitsofe | http://sucs.org/~sits/
