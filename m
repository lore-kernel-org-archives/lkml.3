Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaKMLUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:20:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55880 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbaKMLUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:20:24 -0500
Date: Thu, 13 Nov 2014 12:20:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: Re: [PATCH 6/6] x86: Use clwb in drm_clflush_virt_range
Message-ID: <20141113112017.GA14416@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-7-git-send-email-ross.zwisler@linux.intel.com>
 <5464220D.6090204@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5464220D.6090204@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 07:14:21PM -0800, Andy Lutomirski wrote:
> On 11/11/2014 10:43 AM, Ross Zwisler wrote:
> > If clwb is available on the system, use it in drm_clflush_virt_range.
> > If clwb is not available, fall back to clflushopt if you can.
> > If clflushopt is not supported, fall all the way back to clflush.
> 
> I don't know exactly what drm_clflush_virt_range (and the other
> functions you're modifying similarly) are for, but it seems plausible to
> me that they're used before reads to make sure that non-coherent memory
> sees updated data.  If that's true, then this will break it.

Why would it break it? The updated cachelines will be in memory and
subsequent reads will be serviced from the cache instead from going to
memory as it is not invalidated as it would be by CLFLUSH.

/me is puzzled.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
