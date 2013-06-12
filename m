Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3FLM5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:57:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16210 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3FLM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:57:51 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-2c-51b8704daf10
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
References: <1369825370-31901-1-git-send-email-phil.carmody@partner.samsung.com>
 <1369826652.22004.106.camel@joe-AO722>
In-reply-to: <1369826652.22004.106.camel@joe-AO722>
Subject: RE: [PATCH] checkpatch: forgive use of mixed case variables measuring
 units
Date: Wed, 12 Jun 2013 15:59:21 +0300
Message-id: <003601ce676c$a92360c0$fb6a2240$%carmody@partner.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5cXw4wRHFRbmgKQjurpcfoPS6CrgLDE9TA
Content-language: en-gb
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7q+BTsCDRY+5bX4sFbDYvb9xywW
	l3fNYXNg9pjV0Mvm8WXVNWaPz5vkApijuGxSUnMyy1KL9O0SuDKm7NrIVLCGp6L/2Dq2BsY9
	nF2MnBwSAiYSa5dPYoawxSQu3FvP1sXIxSEksJRR4s/TbnaQhJDAP0aJxsZwEJtNwFRiyopv
	TCC2iICyxIJFn1lAbGYBY4l3Uw8zQ9RXS7xeux6shhMovvDBDjBbWCBM4uXUv4wgNouAqsSl
	JwdZQWxeAU+JKUseM0HYghI/Jt+DmqklsX7ncSYIW15i85q3QPM5gA5Vl3j0VxfiBCOJLVDn
	MAuISzyc0cs0gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525i
	hAT71x2MS49ZHWIU4GBU4uE9YLY9UIg1say4MvcQowQHs5IIb2L8jkAh3pTEyqrUovz4otKc
	1OJDjEwcnFINjAvVZr3tkDw9a0KwuOS/E8xsL+b4TJR12XQ1bKvzmRfzVRc7Vwi8VL+gW3fy
	hHDDpdtsewtvKX+Jzt/0nmma1PW+nTc61j/8euW35tet5UJSO6OrN/VUlsfy/MhTr203aKm5
	8Thi0Z+7a/vrTP67ut/xiehPeHLPLXEX+wsDNaO6F2sEuL/YsCmxFGckGmoxFxUnAgDkZOQK
	VAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2013-05-29 at 14:02 +0300, Phil Carmody wrote:
> > I don't think anyone really has an issue with things like max_mV.
> > And whilst nS et al. may not be SI standard, at least it's clear
> > what they represent.
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -2940,6 +2940,7 @@ sub process {
> >  			if ($var !~ /$Constant/ &&
> >  			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> >  			    $var !~
/"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
> > +			    $var !~ /^[a-z_]*_[numk][VAS]$/ &&
> >  			    !defined $camelcase{$var}) {
> >  				$camelcase{$var} = 1;
> >  				WARN("CAMELCASE",
> 
> Hi Phil.
> 
> CamelCase was downgraded to a --strict only (CHK)
> test in -next recently.  commit f0e8102413
> ("checkpatch: change CamelCase test and make it --strict")
> 
> I'm hesitant to add a longish whitelist inside
> checkpatch itself, but if it's added, it should
> probably be an array.

Thanks for the response, Joe, sorry I didn't reply earlier.

I agree that a creeping list of exceptions where CamelCase
is to be overlooked would be bad, but I would argue that 
perhaps my exceptions aren't actual CamelCase - they're
(pretending to be) SI units, and just happen to match the
CamelCase regexp. I did a grep for my regexp, and everything
I noticed in a quick scan did look like a justifiable 
variable name.

Of course, it's not a biggie either way, and of course it's
your call, but I do feel my patch has enough merit to be
worth defending.

Cheers,
Phil



