Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbaCTVCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:02:11 -0400
Received: from lekensteyn.nl ([178.21.112.251]:38953 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759782AbaCTVCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:02:06 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chaoming_Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] rtlwifi (and staging rtl8821ae) cleanups
Date: Thu, 20 Mar 2014 22:01:49 +0100
Message-ID: <1944222.25WC2qyDiY@al>
User-Agent: KMail/4.12.3 (Linux/3.14.0-rc7-custom-00033-g8878439; KDE/4.12.3; x86_64; ; )
In-Reply-To: <532B4606.3030303@lwfinger.net>
References: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl> <532B4606.3030303@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 14:48:22 Larry Finger wrote:
> On 03/20/2014 01:52 PM, Peter Wu wrote:
> > Hi,
> > 
> > The first patch of these series was NAKed some weeks ago because it would
> > conflict with the new rtl8723be driver. Since those changes are in
> > wireless-next now, I have adjusted that patch to take care of rtl8723be.
> > 
> > The other two patches to the staging driver is similar to the rtlwifi
> > changes. I am not sure who to send these two patches to. Greg is the
> > staging maintainer, but John takes wireless patches, so I have included
> > both of you.
> > 
> > All patches are compile-tested on top of v3.14-rc2-938-g67b3bd4.
> > 
> > I also found the following (unrelated to my patches) warning while
> > compiling the staging driver, perhaps it needs a closer look?
> 
> Peter,
> 
> Your Patch 1/3 applies cleanly and I think it is OK, but if you are going to
> do cleanups on the wireless tree, you should be working from the latest
> version of wireless-testing git repo. We are on 3.14-rc7 and there are
> several recent commits that might have conflicted.

The changes are not new, just updated for the latest wireless-next. I did test 
it on wireless-next, apparently it has not synced with Linus' tree yet:

$ git describe wireless-next/master 
v3.14-rc2-938-g67b3bd4
$ git log --oneline -n4 rtlwifi-wireless-next 
cb39071 staging/rtl8821ae: remove unused allow_all_destaddr function
607693e staging/rtl8821ae: avoid accessing RCR directly
7db8deb rtlwifi: remove unused allow_all_destaddr functions
67b3bd4 brcmfmac: fallback to mimo_bw_cap for older firmwares

> As for the changes to staging/rtl8821ae (No. 2 & 3), once Linus starts the
> merge that will precede the release of 3.15-rc2, the entire code for
> rtl8821ae will be replaced. A cleaned-up version was nearly ready for the
> regular wireless tree in time to make 3.15, but it did not get enough
> testing. As a result, that driver will be in testing for one more cycle. By
> 3.16, it should reside in the regular tree and be out of staging.

I must be missing something, since I subscribed to linux-wireless this month, 
I have not seen discussions about a replacement for rtl8821ae. Is this driver 
not published yet?

> Pushing patches that affect both the regular tree and staging is complicated
> and should be avoided whenever possible.

Ok, I kept those in separate patches, but will send different series next time 
if it is preferred.

Thanks,
Peter

