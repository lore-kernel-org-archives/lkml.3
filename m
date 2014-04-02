Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbaDBP7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:59:06 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:44754 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702AbaDBP7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:59:04 -0400
Date: Wed, 2 Apr 2014 11:58:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Loc Ho <lho@apm.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH libata/for-3.15-fixes] libata: drop COMPILE_TEST from
 AHCI_XGENE
Message-ID: <20140402155859.GB16631@htj.dyndns.org>
References: <20140401184916.GA21938@kroah.com>
 <CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
 <20140402022858.GA4901@kroah.com>
 <CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
 <533C0B45.4050909@ti.com>
 <CAPw-ZTn3_oEMFFNua1zoDibOBJOLC92k7zdc8Do+hk3Ai-BSaw@mail.gmail.com>
 <20140402155357.GA16631@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402155357.GA16631@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 11:53:57AM -0400, Tejun Heo wrote:
>  config AHCI_XGENE
>  	tristate "APM X-Gene 6.0Gbps AHCI SATA host controller support"
> -	depends on ARM64 || COMPILE_TEST
> +	depends on ARM64
>  	select PHY_XGENE

So, an alternative would be doing

	select PHY_XGENE if ARM64

butI don't think it'd be worthwhile to go above and beyond for
COMPILE_TEST and it might cause other linkage issues down the road.

Thanks.

-- 
tejun
