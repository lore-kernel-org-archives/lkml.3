Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaKLQSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:18:12 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51941 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaKLQSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:18:10 -0500
Date: Wed, 12 Nov 2014 08:18:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/123] 3.10.60-stable review
Message-ID: <20141112161806.GB25697@roeck-us.net>
References: <20141112011718.985171261@linuxfoundation.org>
 <5462EE6C.3070202@roeck-us.net>
 <20141112062255.GB3256@kroah.com>
 <20141112072234.GB7367@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112072234.GB7367@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.54638842.0196,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 9
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 04:22:34PM +0900, Greg Kroah-Hartman wrote:
> On Wed, Nov 12, 2014 at 03:22:55PM +0900, Greg Kroah-Hartman wrote:
> > On Tue, Nov 11, 2014 at 09:21:48PM -0800, Guenter Roeck wrote:
> > > On 11/11/2014 05:16 PM, Greg Kroah-Hartman wrote:
> > > >This is the start of the stable review cycle for the 3.10.60 release.
> > > >There are 123 patches in this series, all will be posted as a response
> > > >to this one.  If anyone has any issues with these being applied, please
> > > >let me know.
> > > >
> > > >Responses should be made by Fri Nov 14 01:17:00 UTC 2014.
> > > >Anything received after that time might be too late.
> > > >
> > > 
> > > As an early heads up, I see some builds failing in 3.10 and 3.14 with
> > > 
> > > drivers/of/selftest.c: In function 'of_selftest':
> > > drivers/of/selftest.c:224:2: error: implicit declaration of function 'of_selftest_property_match_string' [-Werror=implicit-function-declaration]
> > >   of_selftest_property_match_string();
> > >   ^
> > > drivers/of/selftest.c: At top level:
> > > drivers/of/selftest.c:129:20: warning: 'of_selftest_property_string' defined but not used [-Wunused-function]
> > >  static void __init of_selftest_property_string(void)
> > >                     ^
> > > 
> > > Not surprising, since commit 'of: Fix overflow bug in string property
> > > parsing functions' replaces the now missing function with the defined
> > > but unused function, apparently without changing the caller.
> > > Oddly enough, the referenced upstream commit _does_ replace the
> > > function name for both caller and callee.
> > 
> > Crap, I took the "ignore the rejects" too literally when applying that
> > patch, let me go rework it and see if I can fix it up.
> 
> And I've fixed it now.  I doubt it's worth rolling a new -rc release for
> this, given the low number of builds that are failing.
> 
Confirmed to be fixed.

Thanks,
Guenter
