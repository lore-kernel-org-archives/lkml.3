Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaKGMMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:12:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57957 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaKGMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:12:43 -0500
Date: Fri, 7 Nov 2014 13:12:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Yucong <slaoub@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
Message-ID: <20141107121239.GA19142@pd.tnic>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
 <20141106153539.GC4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329240AE@ORSMSX114.amr.corp.intel.com>
 <20141106182206.GG4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3292433C@ORSMSX114.amr.corp.intel.com>
 <20141106185638.GH4318@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329246B2@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F329246B2@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:24:01PM +0000, Luck, Tony wrote:
> Architecturally it is true that MCIP will be set when machine check is
> signaled. But, sometimes there are bugs. BIOS has a hook to get an SMI
> to see the event before the OS sees the machine check - which gives
> lots of scope for things to not happen by the book. If MCIP isn't set
> correctly, I'd like to get on and panic quickly - because all sorts
> of bad things will happen if a nested machine check happens and isn't
> caught because MCIP wasn't set in the first machine check.

I won't even ask about your actual experience with stuff not setting
MCIP :-)

Anyway, noted. So for the mce_severity rewrite we should make sure to
note from which context we're being called as the more reliable method,
instead of looking at MCGSTATUS.MCIP.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
