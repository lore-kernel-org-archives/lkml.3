Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3IRPd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:33:58 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:13276 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3IRPd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:33:56 -0400
Message-ID: <1379518432.1522.18.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 003/007] WAN Drivers: Update farsync driver and
 introduce fsflex driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: Kevin Curtis <Kevin.Curtis@farsite.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Dermot Smith" <dermot.smith@farsite.com>
Date: Wed, 18 Sep 2013 16:33:52 +0100
In-Reply-To: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA2@SOLO.hq.farsitecommunications.com>
References: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA2@SOLO.hq.farsitecommunications.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20158.002
X-TM-AS-Result: No--14.583300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 11:12 +0100, Kevin Curtis wrote:
> Farsite Communications FarSync driver update
> 
> Patch 3 of 7
> 
> Introduce a new include file required by the fsflex driver.
> 
> Signed-off-by: Kevin Curtis <kevin.curtis@farsite.com>
> 
> ---
> 
> diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/drivers/net/wan/fscmn.h linux-3.10.1_new/drivers/net/wan/fscmn.h
> --- linux-3.10.1/drivers/net/wan/fscmn.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-3.10.1_new/drivers/net/wan/fscmn.h	2013-09-16 16:30:06.779104868 +0100
[...]
> +#ifdef UINT32
> +#define u32 UINT32
> +#define u16 UINT16
> +#define u8  UCHAR
> +#endif
> +
> +#ifdef USSTYPES_H
> +#define u32 U32
> +#define u16 U16
> +#define u8  U8
> +#endif
[...]

This sort of cruft doesn't belong in an in-tree driver.  unifdef may be
useful for removing it when copying in out-of-tree 'portable' code.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

