Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaG3UAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:00:20 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:33937 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751325AbaG3UAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:00:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3866:3867:3868:3871:4321:5007:7652:7904:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: store17_3c3e081357a39
X-Filterd-Recvd-Size: 1445
Message-ID: <1406750412.12100.65.camel@joe-AO725>
Subject: Re: [PATCH] ACPI: fix test for hex digit.
From: Joe Perches <joe@perches.com>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 13:00:12 -0700
In-Reply-To: <1406749932-1709-1-git-send-email-arjun024@gmail.com>
References: <1406749932-1709-1-git-send-email-arjun024@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-31 at 01:22 +0530, Arjun Sreedharan wrote:
> decimal 0 is ascii for NULL. Hex digit matching should be from '0'
> (decimal 30 of ascii) to '9' and 'A' to 'F'.
> Unfixed version returns true for #,$,%,& etc.
[]
> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
[]
> @@ -322,7 +322,7 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
>  
>  static bool is_hex_digit(char c)
>  {
> -	return (c >= 0 && c <= '9') || (c >= 'A' && c <= 'F');
> +	return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'F');
>  }

Maybe delete this and do s/is_hex_digit/isxdigit/ ?


