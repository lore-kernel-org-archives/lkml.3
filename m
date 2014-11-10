Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaKJVrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:47:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59608 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaKJVrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:47:45 -0500
Date: Mon, 10 Nov 2014 22:47:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Yucong <slaoub@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Message-ID: <20141110214739.GB4366@pd.tnic>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-3-git-send-email-slaoub@gmail.com>
 <20141110190617.GJ4359@pd.tnic>
 <20141110213728.GN4359@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329281E9@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F329281E9@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:44:26PM +0000, Luck, Tony wrote:
> > In fact, you could redo this patch in the meantime without the AMD vendor
> > check so that Tony can pick them up soon. I'll add the correct AMD bits
> > later.
> 
> You just want this hunk deleted ...
> 
> +	if (c->x86_vendor == X86_VENDOR_AMD) {
> +		/*
> +		 * AMD BKDGs - Machine Check Error Codes
> +		 *
> +		 * Bit 8 of ErrCode[15:0] of MCi_STATUS is used for indicating
> +		 * a memory-specific error. Note that this field encodes info-
> +		 * rmation about memory-hierarchy level involved in the error.
> +		 */
> +		return (m->status & 0xff00) == BIT(8);
> +	} else
> 
> I can do that without a repost.  Or I can leave a reminder ...
> 
> +	if (c->x86_vendor == X86_VENDOR_AMD) {
> +		/*
> +		 * coming soon
> +		 */
> +		return false;
> +	} else

Ok, that's fine too. I'll try to have a fix for this very soon so that
we can be just in time ready to go for 3.19.

With that you can slap

Acked-by: Borislav Petkov <bp@suse.de>

to them.

Thanks Tony.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
