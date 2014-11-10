Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaKJR56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:57:58 -0500
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:53826 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752910AbaKJR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:57:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:6261:7875:7903:7974:8603:8825:8985:9025:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12555:12740:13069:13095:13132:13231:13311:13357:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pipe85_27eb837320b3e
X-Filterd-Recvd-Size: 2372
Message-ID: <1415642273.8868.8.camel@perches.com>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 10 Nov 2014 09:57:53 -0800
In-Reply-To: <5460F7D8.2030100@nod.at>
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
	 <5460F7D8.2030100@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 18:37 +0100, Richard Weinberger wrote:
> Am 03.11.2014 um 14:58 schrieb Tanya Brokhman:
> > If there is more then one UBI device mounted, there is no way to
> > distinguish between messages from different UBI devices.
> > Add device number to all ubi layer message types.

Adding "error" and "warning" to the message logs is
duplicative to the KERN_<LEVEL> logging information.

> > Changes from V5:
> > 	- Added ptr verification @ ubi_err/ubi_msg/ubi_warn
> > 	Removed extra printing of ubi number
> > 	Removed new messages.

Did you all ever look at what I posted?

https://lkml.org/lkml/2014/10/14/280

smaller code, consistent prefixing, consistent with
typical kernel style, etc.

> While testing I noticed that the log output looks quite different.
> 
> e.g.
> [   26.564111] UBI-0: ubi_attach_mtd_dev:default fastmap pool size: 256
> [   26.565438] UBI-0: ubi_attach_mtd_dev:default fastmap WL pool size: 128

If __func__ is really desired, it's generally better to
put a space after the "%s:", __func__ so there's visual
separation between the prefixes and the content.

I agree that emitting function names isn't particularly
useful.

(and Richard, do please remember to trim your posts,
 you sent > 100KB of unnecessary quoted stuff)

