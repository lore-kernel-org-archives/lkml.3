Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaJBQj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:39:57 -0400
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:47298 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032AbaJBQjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:39:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1605:1711:1730:1747:1777:1792:2110:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:7903:8828:10007:10226:10400:10450:10455:10471:10848:11026:11232:11473:11658:11914:12517:12519:12663:12740:13071:13255:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: scene68_906da7fc12133
X-Filterd-Recvd-Size: 4028
Message-ID: <1412267991.3247.64.camel@joe-AO725>
Subject: Re: [PATCH v2] staging: rts5208: Clean up coding style in
 rtsx_chip.c to get rid of checkpatch.pl warnings and combine two ifs into
 one
From: Joe Perches <joe@perches.com>
To: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
Cc: gregkh@linuxfoundation.org, micky_ching@realsil.com.cn,
        fabio.falzoi84@gmail.com, mahati.chamarthy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 09:39:51 -0700
In-Reply-To: <542D6E5A.1060601@gmail.com>
References: <542D336A.1050401@gmail.com>
	 <1412250349.3247.44.camel@joe-AO725> <542D6E5A.1060601@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 18:25 +0300, Giedrius Statkevicius wrote:
> On 2014.10.02 14:45, Joe Perches wrote:
> > On Thu, 2014-10-02 at 14:13 +0300, Giedrius Statkevicius wrote:
> >> Fix 10 occurences of coding style errors where the line exceeds 80 characters by breaking them into more lines.
> >> Checkpatch.pl reports these errors as: 'WARNING: line over 80 characters'
> >> Also, removes unnecessary returns in two void functions by removing the return statements.
> >> Checkpatch.pl reports these errors as: 'WARNING: void function return statements are not generally useful'
> >> Lastly it combines two if statements into one in rtsx_reset_chip()
> > 
> > Another way to reduce indentation is to write another
> > utility function like the suggested patch at the end
> > of this email.
[]
> > Using ternaries can also reduce line count and
> > indentation:
> > 	if (something)
> > 		foo(bar, 1, ...);
> > 	else
> > 		foo(bar, 2, ...);
> > can be written
> > 	foo(bar, something ? 1 : 2, ...)
> First of all, the purpose of this trivial patch is to clean the
> simple, obvious coding style mistakes reported by checkpatch.pl to get
> my feet wet as I am a kernel newbie.

Hello Giedrius.

By itself, that's fine.  A mechanical change as a first
contribution as a means to do larger changes is very
welcome, as I hope you are welcomed here.

While mechanical changes have some value, the purpose
of a tool like checkpatch isn't any significant
transformational change, it's a trivial oversight minder.

Fixing checkpatch bleats won't make code "better".

checkpatch really only helps code style conformity.
It tries to help make code a bit more like other code
already in the kernel.
 
People play a larger role in looking at code and
making it cleaner, neater, more intelligible, better
structured, smaller, faster, maintainable, etc.

> Obviously, if we take a look at the code more closely there are many
> problems including the ones you've mentioned.
> For example, in rts5208_init() in atleast in 6 places we can use
> ternaries. This is one of them:
> 
> 	if (val & 0x01)
> 		chip->hw_bypass_sd = 1;
> 	else
> 		chip->hw_bypass_sd = 0; 
> 
> A lot of places where we can combine if's. In rtsx_disable_aspm():
> 
> 	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
> 		if (chip->aspm_enabled) {
> 
> So I guess I should make a way bigger patch that cleans more of the
> coding style mistakes if no one wants to take this patch?
> To be honest, I would like these to be two seperate patches as they do
> different things and not just a big one that does both things as I may
> not be able to do that sucessfully.

Have at it.

Start small, learn a bit, do more, repeat ad libitum...

A series of patches that do single things is much
easier for others to validate, accept and apply.

As long as patches are done in sets of single things,
don't fear making larger transformational changes too.

cheers, Joe

