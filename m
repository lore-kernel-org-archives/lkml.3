Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864Ab3HKERr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 00:17:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3HKERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 00:17:46 -0400
Message-ID: <1376194657.7006.11.camel@marge.simpson.net>
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Date: Sun, 11 Aug 2013 06:17:37 +0200
In-Reply-To: <5206659F.9070705@zytor.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
	 <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net>
	 <5206659F.9070705@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:K/to4Zh8bLPfQ8l+wff6S5rGb/vCTbFKFsYrlxd7r+m
 TKfpjncPKc+ZtW+UNeSrxh/Dq+zi9WFRRxKP1coV/crTGZk400
 Hp/DmIDEA9huaZPQIBqBzhZiHYxKfTthyq6gzytZo+Rd1Btdzl
 tV1yCS3Ut2MMU6kBl0eifX64i3NawXS6jdBuCBZPuZqIcUEcEd
 0uiEXD+bDWQh5Rsbasdl7xZErEfq/eSw3on1tptF1sRIcY6bfr
 3C+447O/CQHVaKIJgXr9JRIemuoqFBgI1Rt4fy9MnZoAcdLW0s
 UraHZIEWK+cRZ/p5UGhVq1/dj/arCPTf4BREk2glcBQwGT7YAi
 E+OlEDy4NPqs4exDG7rGeXHZfNk/S/Vfy/qtqIWxvlQf1O576v
 8Te15ViWYmYjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-10 at 09:09 -0700, H. Peter Anvin wrote: 
> On 08/09/2013 10:55 PM, Mike Galbraith wrote:
> >>
> >> Now, here is a bigger question: shouldn't we be deprecating/getting rid
> >> of PREEMPT_VOUNTARY in favor of PREEMPT?
> > 
> > I sure hope not, PREEMPT munches throughput.  If you need PREEMPT, seems
> > to me what you _really_ need is PREEMPT_RT (the real deal), so
> > eventually depreciating PREEMPT makes more sense to me.
> > 
> 
> Do you have any quantification of "munches throughput?"  It seems odd
> that it would be worse than polling for preempt all over the kernel, but
> perhaps the additional locking is what costs.

I hadn't compared in ages, so made some fresh samples.

Q6600 3.11-rc4

vmark
voluntary     169808     155826     154741     1.000
preempt       149354     124016     128436      .836

That should be ~worst case, it hates preemption. 

tbench 8
voluntary    1027.96    1028.76    1044.60     1.000
preempt       929.06     935.01     928.64      .900

hackbench -l 10000
voluntary     23.146     23.124     23.230     1.000
preempt       25.065     24.633     24.789     1.071

kbuild vmlinux
voluntary  3m44.842s  3m42.975s  3m42.954s     1.000
preempt    3m46.141s  3m45.835s  3m45.953s     1.010

Compute load comparisons are boring 'course.

	-Mike

