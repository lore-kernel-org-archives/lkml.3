Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaDHMpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:45:10 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:47398 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756762AbaDHMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:45:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3871:3874:4321:5007:7514:7652:7875:10004:10400:108
X-HE-Tag: plane05_f4ca8937073f
X-Filterd-Recvd-Size: 2149
Message-ID: <1396961103.2812.4.camel@joe-AO722>
Subject: Re: [PATCH v4] Staging: vt6655: iwctl.c: fix a sparse warning
From: Joe Perches <joe@perches.com>
To: Jimmy Li <coder.liss@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?us-ascii?Q?=3D=3Futf-8=3FB=3FVMO8bGluIMSwemVy=3F=3D?= 
	<tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 05:45:03 -0700
In-Reply-To: <20140408110927.GA17308@gmail.com>
References: <20140408110927.GA17308@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 20:36 +0800, Jimmy Li wrote:
> fix a sparse warning and do some clean up.
> 
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>

The --- line should go here

> v1 fix a sparse warning.
> 	(iwctl.c:1846:35: expected restricted gfp_t [usertype] flags)
> v2 clear up two unnecessary variable, buf and blen.
> v3 fix patch format.
> v4 fix patch format again.
> 
> ---

not here

As is, the versioning information would end up
in the changlog and that isn't the desired style.

> diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
[]
> @@ -1835,19 +1835,14 @@ int iwctl_siwencodeext(struct net_device *dev,
[]
> +	param = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);

Also, param is a struct viawget_wpa_param * so
this should use:

	param = kzalloc(sizeof(*param), GFP_KERNEL);


