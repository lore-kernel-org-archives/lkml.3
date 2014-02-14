Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBNRnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:43:05 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57527 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751385AbaBNRnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:43:04 -0500
Date: Fri, 14 Feb 2014 17:42:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, patches@linaro.org,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 16/22] arm64: Add function to create identity mappings
Message-ID: <20140214174256.GC12304@arm.com>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
 <1391619853-10601-17-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391619853-10601-17-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 05:04:07PM +0000, Leif Lindholm wrote:
> +void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
> +{
> +	pgd_t *pgd = &idmap_pg_dir[pgd_index(addr)];
> +
> +	if (pgd >= &idmap_pg_dir[ARRAY_SIZE(idmap_pg_dir)]) {
> +		pr_warn("BUG: not creating id mapping for 0x%016llx\n", addr);
> +		return;
> +	}
> +	__create_mapping(pgd, addr, addr, size, map_io);
> +}

I'm a bit worried because I gave some feedback in the past but it didn't
make to this patch.

What I said on 22nd of January:

  The condition above is always false since pgd_index() already ands the
  index with (PTRS_PER_PGD - 1). Better check addr against something like
  (PTRS_PER_PGD * PGDIR_SIZE) (for clarity, you could do other shifts,
  doesn't really matter).

-- 
Catalin
