Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbbANSF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:05:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57678 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbANSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:05:57 -0500
Date: Wed, 14 Jan 2015 10:05:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 3.14 00/77] 3.14.29-stable review
Message-ID: <20150114180550.GA13907@roeck-us.net>
References: <20150114072224.182299947@linuxfoundation.org>
 <20150114163721.GA32246@roeck-us.net>
 <54B69DF6.7070306@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B69DF6.7070306@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54B6B005.009A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Wed, Jan 14, 2015 at 05:48:54PM +0100, Jiri Slaby wrote:
> On 01/14/2015, 05:37 PM, Guenter Roeck wrote:
> > On Tue, Jan 13, 2015 at 11:22:40PM -0800, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 3.14.29 release.
> >> There are 77 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Fri Jan 16 07:22:07 UTC 2015.
> >> Anything received after that time might be too late.
> >>
> > There are several powerpc build failures.
> > 
> > Building powerpc:defconfig ... failed
> > Building powerpc:allmodconfig ... failed
> > Building powerpc:cell_defconfig ... failed
> > Building powerpc:maple_defconfig ... failed
> > 
> > arch/powerpc/kernel/head_64.o: In function `machine_check_handle_early':
> > (.text+0x918c): undefined reference to `.power7_enter_nap_mode'
> 
> Dots from functions were removed only in commit b1576fec7f4 (powerpc: No
> need to use dot symbols when branching to a function).
> 
> The backport of commit 8117ac6a6c2 (powerpc/powernv: Switch off MMU
> before entering nap/sleep/rvwinkle mode) should redefine
> power7_enter_nap_mode with dots IMO.
> 
Yes, something like that, or drop that commit for the time being.
Reverting it fixes the problem.

Guenter
