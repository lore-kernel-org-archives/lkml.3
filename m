Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaBQN3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:29:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaBQN3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:29:48 -0500
Message-ID: <1392643756.2771.66.camel@deneb.redhat.com>
Subject: Re: [PATCH 16/22] arm64: Add function to create identity mappings
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        patches@linaro.org
Date: Mon, 17 Feb 2014 08:29:16 -0500
In-Reply-To: <20140214174256.GC12304@arm.com>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
	 <1391619853-10601-17-git-send-email-leif.lindholm@linaro.org>
	 <20140214174256.GC12304@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 17:42 +0000, Catalin Marinas wrote:
> On Wed, Feb 05, 2014 at 05:04:07PM +0000, Leif Lindholm wrote:
> > +void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
> > +{
> > +	pgd_t *pgd = &idmap_pg_dir[pgd_index(addr)];
> > +
> > +	if (pgd >= &idmap_pg_dir[ARRAY_SIZE(idmap_pg_dir)]) {
> > +		pr_warn("BUG: not creating id mapping for 0x%016llx\n", addr);
> > +		return;
> > +	}
> > +	__create_mapping(pgd, addr, addr, size, map_io);
> > +}
> 
> I'm a bit worried because I gave some feedback in the past but it didn't
> make to this patch.
> 
> What I said on 22nd of January:
> 
>   The condition above is always false since pgd_index() already ands the
>   index with (PTRS_PER_PGD - 1). Better check addr against something like
>   (PTRS_PER_PGD * PGDIR_SIZE) (for clarity, you could do other shifts,
>   doesn't really matter).
> 
Sorry about that. I remember making this change but I don't know what
happened to it.


