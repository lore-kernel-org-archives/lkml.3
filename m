Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab3GVV22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:28:28 -0400
Received: from mail-gh0-f176.google.com ([209.85.160.176]:41642 "EHLO
	mail-gh0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab3GVV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:28:27 -0400
Date: Mon, 22 Jul 2013 17:28:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AHCI: fix Null pointer dereference in achi_host_active()
Message-ID: <20130722212822.GB16776@mtj.dyndns.org>
References: <51E53300.6010000@cogentembedded.com>
 <1374041439-34122-1-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374041439-34122-1-git-send-email-xtfeng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Xiaotian.

Thanks for the fix.  A couple comments below.

On Wed, Jul 17, 2013 at 02:10:39PM +0800, Xiaotian Feng wrote:
>  	for (i = 0; i < host->n_ports; i++) {
>  		struct ahci_port_priv *pp = host->ports[i]->private_data;
> +		const char *desc;
>  
> +		if (ata_port_is_dummy(host->ports[i]))
> +			desc = dev_driver_string(host->dev);
> +		else
> +			desc = pp->irq_desc;

I think it'd be better to branch on pp.  ie. do "if (pp) desc =
pp->... " instead and then add a comment saying "pp is NULL for
dummies".

Thanks!

-- 
tejun
