Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3JSVY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:24:57 -0400
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:46190 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751724Ab3JSVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:24:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2526:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3872:3873:3874:4250:4321:5007:6119:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoe86_823a9ecdb9a51
X-Filterd-Recvd-Size: 1801
Message-ID: <1382217893.2041.27.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: add Bluetooth UUID %pU[rR] format specifier
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 19 Oct 2013 14:24:53 -0700
In-Reply-To: <1382199949-26779-1-git-send-email-marcel@holtmann.org>
References: <1382199949-26779-1-git-send-email-marcel@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-19 at 09:25 -0700, Marcel Holtmann wrote:
> The Bluetooth UUID is used in big endian reversed order. Add new
> modifier to print a UUID in big endian, but where the input byte
> stream is actually in reversed order.
> This is similar to %pMR that allows to print a MAC address in
> reversed order since that is how the Bluetooth BD_ADDR is
> actually represented in a byte stream.

Seems sensible.  Other than print_bt_uuid, is
there another place where will it be used?

Are you going to convert print_bt_uuid to use this?

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1106,6 +1106,7 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>  	static const u8 le[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
>  	const u8 *index = be;
>  	bool uc = false;
> +	bool reversed = false;
>  
>  	switch (*(++fmt)) {

Could there ever be a little endian reversed UUID?

Might it be useful to change this to:

	while (isalpha(*++fmt)) {
		switch (*fmt) {

etc?


