Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3BKS2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:28:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57782 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776Ab3BKS2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:28:32 -0500
Date: Mon, 11 Feb 2013 19:28:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] add helper for highmem checks
Message-ID: <20130211182826.GE2683@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, hpa@zytor.com, mingo@kernel.org,
	tglx@linutronix.de
References: <20130208202813.62965F25@kernel.stglabs.ibm.com>
 <20130209094121.GB17728@pd.tnic>
 <20130209104751.GC17728@pd.tnic>
 <51192B39.9060501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51192B39.9060501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 09:32:41AM -0800, Dave Hansen wrote:
> That's crazy. Didn't expect that at all.
>
> I guess X is happier getting an error than getting random pages back.

Yeah, I think this is something special only this window manager wdm
does. The line below has appeared repeatedly in the logs earlier:

Feb  5 23:02:02 a1 wdm: Cannot read randomFile "/dev/mem", errno = 14

This happens when wdm starts so I'm going to guess it uses it for
something funny, "randomFile" it calls it??

With the WARN_ON check added and booting 3.8-rc6, it would choke wdm
somehow and it wouldn't start properly so that even the error out above
doesn't happen. Oh well ...

> I'm working on a set of patches now that should get it _working_
> instead of just returning an error.

Yeah, send them on and I'll run them.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
