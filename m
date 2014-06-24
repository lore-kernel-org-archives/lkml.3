Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaFXSXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:23:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54767 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaFXSXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:23:18 -0400
Date: Tue, 24 Jun 2014 20:23:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        gong.chen@linux.intel.com
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140624182314.GA15068@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
 <20140615163515.GA17016@pd.tnic>
 <20140624173125.GA18045@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140624173125.GA18045@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:31:25PM -0400, Vivek Goyal wrote:
> I think problem is that we shift 1 by 32 bits in this case (31 - 0 +
> 1) and that overflows the size of unsigned. So there is this corner
> case where it does not seem to work (or atleast outputs warning).

Right, that is a corner case which overflows the shift. The only thing I
can think of right now is:

#define GENMASK(h, l)           ((u32)GENMASK_ULL(h, l))

u32 because we're implicitly assuming we're dealing with 32-bit unsigned
quantities.

There might be a better solution though...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
