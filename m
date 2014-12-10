Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbaLJXj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:39:27 -0500
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:48991 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758159AbaLJXj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:39:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:4321:5007:6261:7875:8957:10004:10400:10848:11232:11657:11658:11914:12043:12296:12517:12519:12660:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dolls51_6d3aac90fcc12
X-Filterd-Recvd-Size: 1931
Message-ID: <1418254749.18092.24.camel@perches.com>
Subject: Re: [PATCH v4 1/2] staging: media: lirc: lirc_zilog.c: fix quoted
 strings split across lines
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: m.chehab@samsung.com, jarod@wilsonet.com, gregkh@linuxfoundation.org,
        mahfouz.saif.elyazal@gmail.com, gulsah.1004@gmail.com,
        tuomas.tynkkynen@iki.fi, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Dec 2014 15:39:09 -0800
In-Reply-To: <20141210223339.GA9397@biggie>
References: <20141210223339.GA9397@biggie>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 22:33 +0000, Luis de Bethencourt wrote:
> checkpatch makes an exception to the 80-colum rule for quotes strings, and
> Documentation/CodingStyle recommends not splitting quotes strings across lines
> because it breaks the ability to grep for the string. Fixing these.
[]
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
[]
> @@ -794,9 +796,9 @@ static int fw_load(struct IR_tx *tx)
>  	if (!read_uint8(&data, tx_data->endp, &version))
>  		goto corrupt;
>  	if (version != 1) {
> -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> -			    "1) -- please upgrade to a newer driver",
> -			    version);
> +		dev_err(tx->ir->l.dev,
> +			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver",
> +			version);

Unrelated but this one should have a '\n' termination
at the end of the format.

