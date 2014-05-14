Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaENUH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:07:29 -0400
Received: from smtprelay0137.hostedemail.com ([216.40.44.137]:42211 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156AbaENUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:07:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2538:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7652:8957:9025:9040:10004:10400:10848:11026:11232:11473:11638:11658:11914:12043:12050:12295:12296:12517:12519:12679:12740:13071:13161:13229:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: paint78_637b26222644
X-Filterd-Recvd-Size: 2968
Message-ID: <1400098041.30384.22.camel@joe-AO725>
Subject: Re: [PATCH 0/4] UserModeLinux: Message logging neatening
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Date: Wed, 14 May 2014 13:07:21 -0700
In-Reply-To: <5373C996.7000409@nod.at>
References: <cover.1399678795.git.joe@perches.com> <5373C996.7000409@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 21:52 +0200, Richard Weinberger wrote:
> Am 10.05.2014 01:43, schrieb Joe Perches:
> > Joe Perches (4):
> >   UserModeLinux: Convert UM_KERN_<LEVEL> to KERN_<LEVEL>
> >   UserModeLinux: Remove unused #defines of UM_KERN_<LEVEL>
> >   UserModeLinux: Use a more current logging style
> >   UserModeLinux: Convert printks to pr_<level>

> Thank you Joe!
> I'll queue your patches for 3.16.

(adding Geert to cc's)

Hi Richard.

Please queue only patches 1 and 2.

Patches 3 and 4 are currently defective.
These need a bit of rework to compile appropriately.

I'll do what Al suggested below one day soon.

from: https://lkml.org/lkml/2012/9/29/106

On Sat, Sep 29, 2012 at 10:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Sep 29, 2012 at 10:27:44PM +0200, Geert Uytterhoeven wrote:
>> On Sat, Sep 29, 2012 at 10:10 PM, Joe Perches <joe@perches.com> wrote:
>> >> @@ -88,7 +88,7 @@ static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
>> >>               iocbp->aio_nbytes = sizeof(c);
>> >>               break;
>> >>       default:
>> >> -             printk(UM_KERN_ERR "Bogus op in do_aio - %d\n", type);
>> >> +             printk(KERN_ERR "Bogus op in do_aio - %d\n", type);
>> >
>> > Maybe a follow-on patch to convert these to pr_<level>?
>>
>> That requires adding pr_<level> to arch/um/include/shared/user.h first.
>> Or to avoid duplication, extracting the pr_<level> definitions from
>> include/linux/printk.h to a new header file, and preincluding that one for
>> the user part of UML, too.
>
> Yecchhh....  Just how many of those pre-includes do you want to add?
> Seriously, if we get enough of those, it might make more sense to take
> them into a separate directory and add it to search paths, including
> that for userland objects of uml.  If not, I'd rather copy them to
> include/generated in arch/um/Makefile and explicitly #include <generated/foo.h>
> them from user.h.  It's trivially doable and as long as we have relatively
> few of those guys it's less PITA...

