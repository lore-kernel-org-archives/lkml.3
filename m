Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaCZPRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:17:00 -0400
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:35768 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaCZPQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:16:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3868:4321:5007:7652:10004:10400:10848:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:n
X-HE-Tag: heat03_8f3858a2d4f52
X-Filterd-Recvd-Size: 1852
Message-ID: <1395846982.3726.18.camel@joe-AO722>
Subject: Re: [PATCH] drivers/staging/vt6655/iwctl.c fix a sparse warning
From: Joe Perches <joe@perches.com>
To: Jimmy Li <coder.liss@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?UTF-8?Q?T=C3=BClin_=C4=B0zer?= <tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Mar 2014 08:16:22 -0700
In-Reply-To: <20140326074243.GA15228@gmail.com>
References: <20140326074243.GA15228@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-26 at 00:42 -0700, Jimmy Li wrote:
> fix a sparse warning.
[]
> diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
[]
> @@ -1843,7 +1843,7 @@ int iwctl_siwencodeext(struct net_device *dev,
[]
>  	blen = sizeof(*param);
> -	buf = kmalloc((int)blen, (int)GFP_KERNEL);
> +	buf = kmalloc((int)blen, GFP_KERNEL);
>  	if (buf == NULL)
>  		return -ENOMEM;
>  	memset(buf, 0, blen);

Ideally, this would be

	buf = kzalloc(sizeof(*param), GFP_KERNEL);
	if (!buf)
		return -ENOMEM;

removing the now unused blen variable declaration
and without the now unnecessary memset


