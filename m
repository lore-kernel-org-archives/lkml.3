Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaJBTxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:53:24 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:36071 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752400AbaJBTxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:53:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:196:334:355:368:369:379:541:599:800:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1622:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2687:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6671:7652:7903:9025:9121:10004:10400:10848:11232:11233:11658:11914:12043:12262:12296:12438:12517:12519:12555:12679:12740:13007:13019:13025:13069:13141:13161:13229:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: card21_575356391313d
X-Filterd-Recvd-Size: 2849
Message-ID: <1412279593.3247.73.camel@joe-AO725>
Subject: Re: checkpatch config symbol description false positive
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vadim Bendebury <vbendeb@chromium.org>
Date: Thu, 02 Oct 2014 12:53:13 -0700
In-Reply-To: <1412278315.6504.6.camel@x41>
References: <CAMuHMdWc1X3Jiw3zFs2GsqXKxg-Ti_5fPOSk+DsyUwjvikwz+g@mail.gmail.com>
	 <1412278315.6504.6.camel@x41>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 21:31 +0200, Paul Bolle wrote:
> Geert Uytterhoeven schreef op do 02-10-2014 om 21:08 [+0200]:
> > When running checkpatch on
> > http://marc.info/?l=linux-sh&m=141227657322649&w=2
> > I get a false positive about the Kconfig symbol I just introduced, incl. a help
> > text:
> > 
> > WARNING: please write a paragraph that describes the config symbol fully
> > #60: FILE: arch/arm/Kconfig.debug:702:
> > + config DEBUG_SCIF
> 
> When you add one single line to your help (say, "Bla bla.") the warning
> disappears. So you hit this test:
>     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
> 
> because the paragraph was just three lines. It seems a length of one,
> two, or three lines can be OK. It depends. Perhaps the test should just
> be:
>     [...] && $length);

I generally agree.
I think the 4 line paragraph requirement is a bit much myself.

There is a patch in -next that allows a command line or a
.config file override.

commit 77b0cf564fa797e390e0ea29c953ac32bec87994
Author: Vadim Bendebury <vbendeb@chromium.org>
Date:   Fri Sep 26 10:19:28 2014 +1000

    checkpatch: allow optional shorter config descriptions
    
    This script is used by many other projects, and in some of them the
    requirement of at least 4 line long description for all Kconfig items is
    excessive.  This patch adds a command line option to control the required
    minimum length.
    
    Tested running this script over a patch including a two line config
    description.  The script generated a warning when invoked as is, and did
    not generate it when invoked with --min-conf-desc-length=2.
    
    Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
    Acked-by: Joe Perches <joe@perches.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>



