Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaAVRkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:40:04 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42716 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752311AbaAVRkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:40:02 -0500
Date: Wed, 22 Jan 2014 17:39:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/6] arm64: Add function to create identity mappings
Message-ID: <20140122173927.GE8065@arm.com>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
 <1389392950-22457-3-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389392950-22457-3-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:29:06PM +0000, Mark Salter wrote:
> +void __init create_id_mapping(phys_addr_t addr, phys_addr_t size)
> +{
> +	pgd_t *pgd = &idmap_pg_dir[pgd_index(addr)];
> +
> +	if (pgd >= &idmap_pg_dir[ARRAY_SIZE(idmap_pg_dir)]) {
> +		pr_warn("BUG: not creating id mapping for 0x%016llx\n", addr);
> +		return;
> +	}

The condition above is always false since pgd_index() already ands the
index with (PTRS_PER_PGD - 1). Better check addr against something like
(PTRS_PER_PGD * PGDIR_SIZE) (for clarity, you could do other shifts,
doesn't really matter).

-- 
Catalin
