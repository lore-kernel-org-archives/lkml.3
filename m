Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaJNRQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:16:01 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:39735 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753866AbaJNRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:15:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:7901:10004:10400:10848:11232:11658:11914:12517:12519:12679:12740:13069:13095:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nest21_8b4297ecaca3e
X-Filterd-Recvd-Size: 1554
Message-ID: <1413306955.3269.30.camel@joe-AO725>
Subject: Re: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by kzalloc
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 14 Oct 2014 10:15:55 -0700
In-Reply-To: <1413304831-7203-1-git-send-email-fabf@skynet.be>
References: <1413304831-7203-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 18:40 +0200, Fabian Frederick wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

It might be clearer to use a structure for this 16 byte thing.

There's a comment bit in the code:

/* cmdreq message: 
	u32 type
	u16 cmd
	u16 parm0
	u16 parm1
	u16 parm2
	u8  pad[4]

	total: 4 + 2 + 2 + 2 + 2 + 4 = 16
*/

It seems thought that this first u32 is actually
a series of u8s.

Maybe:

struct zd1201_cmdreq {
	u8	type;
	u8	seq;
	u8	a;
	u8	b;
	__le16	cmd;
	__le16	parm0;
	__le16	parm1;
	__le16	parm2;
	u8	pad[4];
};

And does this really need to be alloc'd?

maybe

struct zd1202_cmdreq request = {};

etc...

