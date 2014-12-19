Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaLSSeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:34:21 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:46488 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLSSeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:34:19 -0500
Date: Fri, 19 Dec 2014 10:33:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i8k: Autodetect maximal fan speed and fan RPM
 multiplier
Message-ID: <20141219183343.GB6767@roeck-us.net>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
 <201412101250.13891@pali>
 <548853CB.7000704@roeck-us.net>
 <201412181213.36143@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412181213.36143@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54946FB4.0150,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 17
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

On Thu, Dec 18, 2014 at 12:13:35PM +0100, Pali Rohár wrote:
> On Wednesday 10 December 2014 15:08:11 Guenter Roeck wrote:
> > On 12/10/2014 03:50 AM, Pali Rohár wrote:
> > > On Tuesday 09 December 2014 23:42:08 Guenter Roeck wrote:
> > >> On Tue, Dec 09, 2014 at 09:23:22PM +0100, Pali Rohár wrote:
> > >>> On Tuesday 09 December 2014 21:20:23 Guenter Roeck wrote:
> > >>>> On Tue, Dec 09, 2014 at 09:07:00PM +0100, Pali Rohár 
> wrote:
> > >>>>> This patch adds new function i8k_get_fan_nominal_rpm()
> > >>>>> for doing SMM call which will return nominal fan RPM
> > >>>>> for specified fan speed. It returns nominal RPM value
> > >>>>> at which fan operate when speed is set. It looks like
> > >>>>> RPM value is not accurate, but still provides very
> > >>>>> useful information.
> > >>>>> 
> > >>>>> First it can be used to validate if certain fan speed
> > >>>>> could be accepted by SMM for setting fan speed and we
> > >>>>> can use this routine to detect maximal fan speed.
> > >>>>> 
> > >>>>> Second it returns RPM value, so we can check if value
> > >>>>> looks correct with multiplier 30 or multiplier 1 (until
> > >>>>> now only these two multiplier was used). If RPM value
> > >>>>> with multiplier 30 is too high, then multiplier 1 is
> > >>>>> used.
> > >>>>> 
> > >>>>> In case when SMM reports that new function is not
> > >>>>> supported we will fallback to old hardcoded values.
> > >>>>> Maximal fan speed would be 2 and RPM multiplier 30.
> > >>>>> 
> > >>>>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > >>>>> ---
> > >>>>> I tested this patch only on my Dell Latitude E6440 and
> > >>>>> autodetection worked fine Before appying this patch it
> > >>>>> should be tested on some other dell machines too but if
> > >>>>> machine does not support i8k_get_fan_nominal_rpm()
> > >>>>> driver should fallback to old values. So patch should
> > >>>>> be without regressions.
> > >>>> 
> > >>>> It looks like many of your error checks are unnecessary.
> > >>>> Why did you add those ?
> > >>>> 
> > >>>> Please refrain from adding unnecessary code.
> > >>>> 
> > >>>> Guenter
> > >>> 
> > >>> Which error checks do you mean?
> > >> 
> > >> There are several you added. I noticed the ones around
> > >> 'index', which would only be hit on coding errors. At that
> > >> point I stopped looking further and did not verify which of
> > >> the other added error checks are unnecessary as well.
> > >> 
> > >> A quick additional check reveals that the fan variable
> > >> range check in i8k_get_fan_nominal_rpm is completely
> > >> unnecessary - if the range was wrong, the calling code
> > >> would fail as well, since you unconditionally write into
> > >> an array indexed by the very same variable. Given the
> > >> simplicity of the calling code, it can even be
> > >> mathematically proven that the error condition you are
> > >> checking can never happen.
> > >> 
> > >> With that I really stopped looking further.
> > >> 
> > >> Guenter
> > > 
> > > Should I remove those access out-of-array checks?
> > 
> > If you want me to look into it further. In general, I don't
> > accept code like this, since it increases kernel size for no
> > good reason. It also makes it more difficult to find _real_
> > problems in the code since it distracts from seeing those.
> > 
> > Guenter
> 
> Ok, I will rework this patch and drop that first cosmetic.
> 
Fine, but as mentioned before I still dislike unnecessary
value range checks.

Guenter
