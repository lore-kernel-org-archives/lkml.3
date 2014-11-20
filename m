Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaKTKPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:15:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40099 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbaKTKPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:15:07 -0500
Date: Thu, 20 Nov 2014 11:15:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "ruiv.wang@gmail.com" <ruiv.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Message-ID: <20141120101505.GA791@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:34:10PM +0000, Luck, Tony wrote:
> The SDM has this to say about EN=0 (in section 15.10.4.1 of volume 3B):
> 
>    When the EN flag is zero but the VAL and UC flags are one in
>    the IA32_MCi_STATUS register, the reported uncorrected error
>    in this bank is not enabled. As uncorrected errors with the
>    EN flag = 0 are not the source of machine check exceptions,
>    the MCE handler should log and clear non-enabled errors when
>    the S bit is set and should continue searching for enabled
>    errors from the other IA32_MCi_STATUS registers. Note that
>    when IA32_MCG_CAP [24] is 0, any uncorrected error condition
>    (VAL =1 and UC=1) including the one with the EN flag cleared
>    are fatal and the handler must signal the operating system to
>    reset the system. For the errors that do not generate machine
>    check exceptions, the EN flag has no meaning.
> 
> Note the "should log and clear".  We just clear ... just need to shuffle some code
> in mce.c to add the logging.

Sure, we can log those.

> But we still need something like Rui's patch - calling mcelog()
> doesn't ensure that we see something on the console about possible
> cause of the problem.

So you're saying we should drain the mcelog buffer to the console in
such situations before we panic? If so, there's drain_mcelog_buffer()
which could be changed to call print_mce() instead of going to the
x86_mce_decoder_chain.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
