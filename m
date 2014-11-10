Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaKJWRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:17:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34939 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaKJWRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:17:31 -0500
Date: Mon, 10 Nov 2014 23:17:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: Chen Yucong <slaoub@gmail.com>, tony.luck@intel.com, ak@linux.intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Message-ID: <20141110221728.GA23419@pd.tnic>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
 <546136C8.5060104@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <546136C8.5060104@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:06:00PM -0600, Aravind Gopalakrishnan wrote:
> >+	MCESEV(
> >+		DEFERRED, "Deferred error",
> >+		NOSER, MASK(MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON, MCI_STATUS_DEFERRED)
> >  		),
> 
> We don't need to have MCI_STATUS_POISON in the MASK() here as a deferred
> error is indicated by a {UC=0, Deferred = 1}
> (Older docs might be unclear on that..)

Well, I think that's ok because the MASK() macro actually makes the
check do:

look at bits MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON and of
them three MCI_STATUS_DEFERRED has to be the only one set.

And that makes sense - we want deferred errors where we didn't attempt
to consume poisoned data (which is signalled by MCI_STATUS_POISON)....

Provided I'm reading this mce_severity thing correct, of course - more
often than not I don't because it is insanely ugly and hard to read.

> And it still says ADM on the commit message :)

Yeah, Advanced Devices Micro - that's the new name. :-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
