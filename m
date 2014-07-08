Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaGHQdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:33:39 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:50773 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753633AbaGHQdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:33:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:3872:4250:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12663:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kick01_1f1b8a0ea2030
X-Filterd-Recvd-Size: 1522
Message-ID: <1404837211.932.18.camel@joe-AO725>
Subject: Re: [PATCH v2 2/4] Staging: rts5208: Replace custom macro with
 print_hex_dump_bytes
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Fabio Falzoi <fabio.falzoi84@gmail.com>,
        micky <micky_ching@realsil.com.cn>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, wei_wang@realsil.com.cn,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2014 09:33:31 -0700
In-Reply-To: <20140708084517.GG25880@mwanda>
References: <1404717004-29540-1-git-send-email-fabio.falzoi84@gmail.com>
	 <1404717004-29540-3-git-send-email-fabio.falzoi84@gmail.com>
	 <53BB538C.1080605@realsil.com.cn>
	 <CACar8LkcvOc5dEkFp2pCMmtiO=e7_zOK-2NYhGz6AmQYu2bh-g@mail.gmail.com>
	 <20140708084517.GG25880@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 11:45 +0300, Dan Carpenter wrote:
> On Tue, Jul 08, 2014 at 08:23:02AM +0200, Fabio Falzoi wrote:
> I'm gonna fix it, thanks.
> And leave out the semi-colon as well.

another way to do this is:

static void rtsx_hex_dump(void *buf, size_t len)
{
#if DEBUG
	print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, buf, len);
#endif
}


