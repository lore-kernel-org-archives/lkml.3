Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3JUHOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:14:06 -0400
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:59365 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752685Ab3JUHOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:14:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3872:3873:3874:4250:4321:4362:5007:6119:6238:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stamp80_5d74086bef93f
X-Filterd-Recvd-Size: 2193
Message-ID: <1382339640.2041.70.camel@joe-AO722>
Subject: Re: [PATCH v2] vsprintf: add Bluetooth UUID %pU[rR] format specifier
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 21 Oct 2013 00:14:00 -0700
In-Reply-To: <1382301371-20428-1-git-send-email-marcel@holtmann.org>
References: <1382301371-20428-1-git-send-email-marcel@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-20 at 13:36 -0700, Marcel Holtmann wrote:
> The Bluetooth UUID is used in big endian reversed order. Add new
> modifier to print a UUID in big endian, but where the input byte
> stream is actually in reversed order.

Thanks Marcel.

This looks fine to me but for one nit that you
didn't add.

> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
[]
> @@ -159,12 +159,18 @@ UUID/GUID addresses:
>  	%pUB	00010203-0405-0607-0809-0A0B0C0D0E0F
>  	%pUl	03020100-0504-0706-0809-0a0b0c0e0e0f
>  	%pUL	03020100-0504-0706-0809-0A0B0C0E0E0F
> +	%pUr	0f0e0d0c-0b0a-0908-0706-050403020100
> +	%pUR	0F0E0D0C-0B0A-0908-0706-050403020100
>  
>  	For printing 16-byte UUID/GUIDs addresses. The additional 'l', 'L',
>  	'b' and 'B' specifiers are used to specify a little endian order in
>  	lower ('l') or upper case ('L') hex characters - and big endian order
>  	in lower ('b') or upper case ('B') hex characters.
>  
> +	The additional 'r' and 'R' specifiers are used to specify reversed
> +	big endian order in either lower ('r') or upper case ('R') hex
> +	characters. This is useful for Bluetooth UUID addresses.
> +
>  	Where no additional specifiers are used the default little endian
>  	order with lower case hex characters will be printed.

The default is actually big endian lower case

It'd be nice to fix after this is accepted.

