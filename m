Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbaDJTfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:35:04 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:51026 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaDJTe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:34:58 -0400
Date: Thu, 10 Apr 2014 21:34:46 +0200
From: Rabin Vincent <rabin@rab.in>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: [PATCH 2/2] arm: use fixmap for text patching when text is RO
Message-ID: <20140410193433.GA22746@debian>
References: <1396646870-29695-1-git-send-email-rabin@rab.in>
 <1396646870-29695-2-git-send-email-rabin@rab.in>
 <1396879071.3654.43.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396879071.3654.43.camel@linaro1.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 02:57:51PM +0100, Jon Medhurst (Tixy) wrote:
> How does fixmap cope with cache colouring? Looking at the implementation
> it looks like it doesn't and so fixmap use on ARM is possibly buggy.
> 
> For the text patching case where we know there are no writeable mappings
> [1] this should be OK if we used set_fixmap_nocache here, so long as we
> also invalidated the dcache later for the proper virtual address.

OK.  The dcache invalidation for the proper virtual address is btw
already there via the call to flush_icache_range().

> [1] Can we know there are no writeable mappings though, the ftrace code
> modifying patches from Kees Cook have there own way of modifying text
> code permissions.

The ftrace patches does the modifications and the cache cleaning in
stop_machine(), so there should not be any dirty cache lines from those
writable mappings when we set up and write to these fixmaps.  Do you
still see a problem?
