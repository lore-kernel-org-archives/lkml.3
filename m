Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaERQf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:35:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45782 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaERQf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:35:28 -0400
Date: Sun, 18 May 2014 18:35:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Distirbute the clear operation of mces_seen to
 Per-CPU rather than only monarch CPU
Message-ID: <20140518163508.GA8003@pd.tnic>
References: <1400425504-8821-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400425504-8821-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 11:05:04PM +0800, Chen Yucong wrote:a
> mces_seen is a Per-CPU variable which should only be accessed by
> Per-CPU as possible. So the clear operation of mces_seen should also
> be lcoal to Per-CPU rather than monarch CPU.

No, you need to do the cleaning in mce_reign because the monarch cpu has
to run last after all other cpus have scanned their mce banks.

> Meanwhile, there is also a potential risk that mces_seen will not
> be be cleared if a timeout occors in mce_end for monarch CPU. As a
> reuslt, the stale value of mces_seen will reappear on the next mce.

If that happens, we have a bigger problem.

Is that a real issue you're trying to address?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
