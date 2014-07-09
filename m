Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaGIBsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:48:23 -0400
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:33757 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751112AbaGIBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:48:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:4250:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: silk19_48c43b6426c47
X-Filterd-Recvd-Size: 1783
Message-ID: <1404870498.932.79.camel@joe-AO725>
Subject: Re: [PATCH v3 2/4] Staging: rts5208: Replace custom macro with
 print_hex_dump_bytes
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Fabio Falzoi <fabio.falzoi84@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn
Date: Tue, 08 Jul 2014 18:48:18 -0700
In-Reply-To: <20140708234529.GA25645@kroah.com>
References: <1404855512-5864-1-git-send-email-fabio.falzoi84@gmail.com>
	 <1404855512-5864-3-git-send-email-fabio.falzoi84@gmail.com>
	 <20140708234529.GA25645@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 16:45 -0700, Greg KH wrote:
> On Tue, Jul 08, 2014 at 11:38:30PM +0200, Fabio Falzoi wrote:
> > Use print_hex_dump_bytes to have memory properly dumped only when
> > DEBUG is defined.
[]
> > diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
[]
> > @@ -82,12 +82,11 @@ static inline char *filename(char *path)
[]
> > +static inline void rtsx_hex_dump(const void *buf, size_t len)
> > +{
> > +#ifdef DEBUG
> > +	print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, buf, len);
> >  #endif
> > +}
> 
> What a mess.  What's wrong with just using the %*ph modifier in
> dev_dbg() like other drivers do?

Dunno.
Is it ever desired to emit more than 64 bytes of buf?


