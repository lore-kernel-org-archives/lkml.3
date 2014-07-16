Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbaGPEUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:20:38 -0400
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:33726 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759017AbaGPEUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:20:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1500:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4184:4321:4605:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13095:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skirt63_3f31c7c63da31
X-Filterd-Recvd-Size: 1814
Message-ID: <1405484432.14773.19.camel@joe-AO725>
Subject: Re: [Bug report] Hit false positives bug with script/checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: anish@chelsio.com, apw@canonical.com, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com, joe.jin@oracle.com
Date: Tue, 15 Jul 2014 21:20:32 -0700
In-Reply-To: <1405479036-6763-1-git-send-email-ethan.zhao@oracle.com>
References: <1405479036-6763-1-git-send-email-ethan.zhao@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 10:50 +0800, Ethan Zhao wrote:
> Hi,
>      I hit a false positives bug when run script/checkpatch.pl to my patch,
> It reported  errors to following macro definition, but in fact the macro is
> correct, I couldn't change that macro according to the error message output
> by script/checkpatch.pl. because of this bug, my patch was rejected by some
> guy's patchwork.

You could tell the guy checkpatch isn't always right.

You could also change the macro to something like:

#define NETXEN_NIC_STAT(name, m)				\
{								\
	.name = name,						\
	.type = m,						\
	.sizeof_stat = FIELD_SIZEOF(struct netxen_adapter, m),	\
	.stat_offset = offsetof(struct netxen_adapter, m)	\
}

and change the uses like:

static const struct netxen_nic_stats netxen_nic_gstrings_stats[] = {
	NETXEN_NIC_STAT("xmit called", stats.xmitcalled),
	NETXEN_NIC_STAT("xmit_finished", stats.xmitfinished),

etc...


