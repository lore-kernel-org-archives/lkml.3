Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaGITR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:17:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41894 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbaGITRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:17:55 -0400
Date: Wed, 9 Jul 2014 21:17:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140709191747.GB5249@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-2-git-send-email-hskinnemoen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404925766-32253-2-git-send-email-hskinnemoen@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 10:09:21AM -0700, Havard Skinnemoen wrote:
> From: Ewout van Bekkum <ewout@google.com>
> 
> The CMCI poll interval was updated to pick the minimum interval between
> the original 30 seconds and the check_interval divided by 8 (minimum of
> 3 polls).

Why min 3 polls? How do you come up with exactly that frequency?

> This resolves a bug where the CMCI storm handler is unable to return to
> interrupt mode from polling mode, if the check_interval shorter than the
> CMCI poll interval. This problem is caused by the mce_timer_fn function
> which only allows the poll interval to be incremented up to the
> check_interval, while the mce_intel_adjust_timer function requires the
> poll interval to be greater than the CMCI poll interval before leaving
> the CMCI_STORM_ACTIVE state.

Interesting. So it seems you guys want to set the check_interval to
something < 30 secs.

Out of curiosity, what is your use case which requires such small
check_interval setting?

Maybe we need to redesign and simplify this intervals thing to make it
more user-friendly...

Btw, on a related note, we're working on a small mechanism which
collects correctable errors in the kernel and when a certain count for a
physical error address has been reached, we soft-offline that page. We'd
appreciate it if you guys took a look and told us whether it makes sense
to you:

http://lkml.kernel.org/r/1404242623-10094-1-git-send-email-bp@alien8.de

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
