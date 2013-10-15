Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab3JOMuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:50:37 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:45960 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab3JOMuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:50:35 -0400
Date: Tue, 15 Oct 2013 08:50:31 -0400
From: Tejun Heo <tj@kernel.org>
To: xiangliang yu <yxlraid@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
Message-ID: <20131015125031.GC3141@htj.dyndns.org>
References: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
 <20130928114950.GA2620@htj.dyndns.org>
 <CAP0P+NUvaLfXkOUGm8NX19AHvTHmU=Ya0NdFvyJc2gFjN-Cy0A@mail.gmail.com>
 <20130928131059.GA3945@htj.dyndns.org>
 <CAP0P+NXD7pdXQwBUZJdUwyCc=o_5iTzmKJ6FdN6LrqcgX3yK2A@mail.gmail.com>
 <20131013195735.GD18075@htj.dyndns.org>
 <CAP0P+NWw2goofPtk5v8qKqAkhGwVJ7Bwn+Pj6meNhyK3KE2CAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP0P+NWw2goofPtk5v8qKqAkhGwVJ7Bwn+Pj6meNhyK3KE2CAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 15, 2013 at 11:40:27AM +0800, xiangliang yu wrote:
> @@ -1278,6 +1280,11 @@ int ahci_do_softreset(struct ata_link *link,
> unsigned int *class,
>   if (rc && rc != -EOPNOTSUPP)
>   ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
> 

Please add a comment here.

> + if (!ata_is_host_link(link) && pp->fbs_enabled) {
> + ahci_disable_fbs(ap);
> + fbs_flag = true;
> + }

White space damaged?

> +
>   ata_tf_init(link->device, &tf);
> 
>   /* issue the first D2H Register FIS */
> @@ -1318,6 +1325,9 @@ int ahci_do_softreset(struct ata_link *link,
> unsigned int *class,
>   } else
>   *class = ahci_dev_classify(ap);
> 
> + if (fbs_flag)
> + ahci_enable_fbs(ap);
> +

Thanks.

-- 
tejun
