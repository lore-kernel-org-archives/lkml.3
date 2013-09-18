Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab3IRFgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 01:36:55 -0400
Received: from smtprelay0040.hostedemail.com ([216.40.44.40]:47540 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751645Ab3IRFgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 01:36:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0
X-HE-Tag: map74_5901db2133b0e
X-Filterd-Recvd-Size: 2172
Message-ID: <1379482610.1787.7.camel@joe-AO722>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
From: Joe Perches <joe@perches.com>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Date: Tue, 17 Sep 2013 22:36:50 -0700
In-Reply-To: <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
	 <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 18:08 -0500, danielfsantos@att.net wrote:
> This adds an extension for the integral format specifier suffix of 'e',
> so that the format %[duxXo]e will result in printing an number (as
> before) in addition to a name and descrption for an error code, if such
> support is enabled and a name and descrption is found.
> 
> My initial thought was to use the glibc extension of '%m', but this
> format specifier uses the value of libc's errno and adding a value
> breaks gcc's printf parsing.  I'm not convinced that the 'e' extension
> is optimal, although there are only four instances of this pattern in
> the kernel that would need to be changed.
> 
>     git grep -E '".*%[#0\ +\-]*[0-9]*[hljzt]*[idoxXu]e'
> 
> Alternatively, 'E' was another thought for a suffix as well.

I'd much rather see another %p extension used instead
of generating odd output given normal printf formats.

%pE might work


