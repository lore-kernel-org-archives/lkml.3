Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbbATRNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:13:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41455 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbATRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:13:33 -0500
Date: Tue, 20 Jan 2015 09:13:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel <kernel@savoirfairelinux.com>
Subject: Re: [PATCH 2/3] sysfs: Only accept read/write permissions for file
 attributes
Message-ID: <20150120171312.GA24203@roeck-us.net>
References: <54BDC087.4010906@roeck-us.net>
 <1272429736.105015.1421768641283.JavaMail.root@mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272429736.105015.1421768641283.JavaMail.root@mail>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54BE8CBC.0362,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On Tue, Jan 20, 2015 at 10:44:01AM -0500, Vivien Didelot wrote:
> Hi Guenter,
> 
[ ... ]
> 
> > Anyway, my goal was to keep things simple. Taking some bits from the default
> > and others from the return value of the is_visible function isn't simple,
> > even more so since your code would require the is_visible function to mask
> > out SYSFS_PREALLOC to avoid the warning.
> 
> While I'm still not sure about the consequences of flipping this SYSFS_PREALLOC
> bit at runtime, I do agree with your goal.
> 
> Then to keep it simple, the scope of is_visible could be limited to any bit
> allowed at attribute declaration (using *_ATTR* macros). The compile-time check
> macro VERIFY_OCTAL_PERMISSIONS() allows any bit but S_IWOTH. The scope can be
> SYSFS_PREALLOC | 0775. (or 0664 if we want to avoid executables as well.)
> 
> [ This will prevent some follow-up patches "avoid world-writable sysfs files".
> In the future, we may want a runtime equivalent of VERIFY_OCTAL_PERMISSIONS. ]
> 
0775 and 0664 are both fine with me, with a preference for 0664. Before I
resubmit - Greg, any preference from your side ?

Thanks,
Guenter
