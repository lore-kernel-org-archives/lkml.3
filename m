Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbaLINiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:38:55 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15414 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbaLINix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:38:53 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-97-5486fb6a3979
Message-id: <1418132328.19339.9.camel@AMDC1943>
Subject: Re: linux-next: manual merge of the slave-dma tree with the arm tree
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Tue, 09 Dec 2014 14:38:48 +0100
In-reply-to: <20141209140901.685bb382@canb.auug.org.au>
References: <20141209140901.685bb382@canb.auug.org.au>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xq7pZv9tCDFacZrK4vGsOm8XBhW2M
	Frcv81ps3bSX2WLr3qvsFi/79rM4sHm0NPeweTTeuMHm8WTTRUaPxXteMnl83iQXwBrFZZOS
	mpNZllqkb5fAlbH8cVzBCY6KSbfWsjYwXmTrYuTkkBAwkeg+cZAJwhaTuHBvPVCci0NIYCmj
	xKx1H1khnM+MEo1b5rKAVPEK6EtsvL8RrENYwFfi3+F1jCA2m4CxxOblS4C6OThEBLQlDvwW
	AOllFtjDKNG5qhVsG4uAqkTj781MIDWcAuYSO+b5gYSFBMwk2l88ZgexmQXUJSbNW8QMUiIh
	oCzR2O8GsVVQ4sfkeywQJfISm9e8ZZ7AKDALSccsJGWzkJQtYGRexSiaWppcUJyUnmuoV5yY
	W1yal66XnJ+7iRES1F92MC4+ZnWIUYCDUYmH11yxNUSINbGsuDL3EKMEB7OSCO+Uo20hQrwp
	iZVVqUX58UWlOanFhxiZODilGhgn1EQoZiTvmLXj8JqUU9feP9Z4u/jPv+uSF9TUNzIZn73j
	+egte91Z/Ut3+vR3fTum0fxR6564rxJH0Ab34nBzUe7mu8aTbpo82Nm4bP5NJTajikLFSVMP
	/F74Nu7GJp6U+BVz1zNY9p8O//na8AD3xsoPhjvf77liYLIh2JGnKWpPy7cTJ7yPKLEUZyQa
	ajEXFScCAFTIjKdIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-12-09 at 14:09 +1100, Stephen Rothwell wrote:
> Hi Vinod,
> 
> Today's linux-next merge of the slave-dma tree got a conflict in
> drivers/dma/pl330.c between commits ae43b3289186 ("ARM: 8202/1:
> dmaengine: pl330: Add runtime Power Management support v12") and
> b816ccc5c01f ("ARM: 8206/1: dmaengine: pl330: Add PM sleep support")
> from the arm tree and commits 86e15941d3f5 ("dmaengine: pl330: Split
> device_control") and c9a09dacf851 ("dmaengine: pl330: Declare slave
> capabilities for the generic code") from the slave-dma tree.
> 
> I fixed it up (hopefully - see below) and can carry the fix as
> necessary (no action is required).

Looks almost good:
++      pm_runtime_mark_last_busy(pl330->ddma.dev);
++      pm_runtime_put_autosuspend(pl330->ddma.dev);1
                                                    ^here

However I am looking current next (fetched few minutes ago and the one
visible through gitweb) and I can see only mi changes (related to PM
runtime). It looks like slave-dma changes got lost on the way.

Best regards,
Krzysztof


