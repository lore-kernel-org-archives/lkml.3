Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073Ab3JPRCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:02:32 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:35675 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761038Ab3JPRC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:02:29 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-97-525ec6a42240
Date: Wed, 16 Oct 2013 14:02:21 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
Message-id: <20131016140221.6f2299d8@samsung.com>
In-reply-to: <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/hEN0lx+KCDD7MVbVoO/GbzeLzhn9s
	Frfe2VrMvv+YxWL5vn5Gi8u75rBZ3G95ym6x7uELJovVKx+zW6yff4vN4s2FeywO3B7fW/tY
	PBbvecnk8erCHRaPeScDPR4c2szi8WXVNWaP9/uusnkcv7GdyePzJjmPBTP+swRwRXHZpKTm
	ZJalFunbJXBlXN8jVXDTteLPismsDYy3zLoYOTkkBEwk+g79ZYewxSQu3FvP1sXIxSEksIRR
	Yk3HC3YIp5tJ4trGt2BVLAKqEh0bVjGB2GwCRhKvGltYQWwRAR2JB5tWM4I0MAscZJI4fe8d
	M0hCWMBLYln7UTCbV8BQon3BEUYQmxMo/nxqGyPEhk5GidZln4AcDqA7nCS2TvWFqBeU+DH5
	HguIzSygJbF5WxMrhC0vsXnNW+YJjAKzkJTNQlI2C0nZAkbmVYyipcXJBcVJ6blGesWJucWl
	eel6yfm5mxgh0VO8g/HFBqtDjAIcjEo8vDOWxwUJsSaWFVfmHmKU4GBWEuH9tBUoxJuSWFmV
	WpQfX1Sak1p8iJGJg1OqgTHa5qCB8pHTCzrS7k/3rpmkz/56s6li86xH9w9xtKzImPhp89X0
	GTZT1nfO855zqDPo0zWriq+6FaHafFkH+7h19x7NMyzfyjL9tzCX5PGY6hfKpwJNnX5n5BkL
	/PfPu8EssU1R9UTkrh4rFsuTEYbmdixdJ8zkjQSuf5zDr6r+tyouqmD6bSWW4oxEQy3mouJE
	AIrEccZ8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 10:56:00 -0400
"Chen, Gong" <gong.chen@linux.intel.com> escreveu:

> GENMASK is used to create a contiguous bitmask([hi:lo]). It is
> implemented twice in current kernel. One is in EDAC driver, the other
> is in SiS/XGI FB driver. Move it to a more generic place for other
> usage.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Thomas Winischhofer <thomas@winischhofer.net>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Btw, there's another incarnation of it at sb_edac.c (GET_BITFIELD).
It could make sense to also replace it by the newly bitops.h macro.

Regards,
Mauro


> ---
>  drivers/edac/amd64_edac.c | 46 ++++++++++++++++++++++++----------------------
>  drivers/edac/amd64_edac.h |  8 --------
>  drivers/video/sis/init.c  |  5 ++---
>  include/linux/bitops.h    |  8 ++++++++
>  4 files changed, 34 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 3c9e4e9..b53d0de 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -339,8 +339,8 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
>  	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
>  		csbase		= pvt->csels[dct].csbases[csrow];
>  		csmask		= pvt->csels[dct].csmasks[csrow];
> -		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
> -		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
> +		base_bits	= GENMASK_ULL(31, 21) | GENMASK_ULL(15, 9);
> +		mask_bits	= GENMASK_ULL(29, 21) | GENMASK_ULL(15, 9);
>  		addr_shift	= 4;
>  
>  	/*
> @@ -352,16 +352,16 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
>  		csbase          = pvt->csels[dct].csbases[csrow];
>  		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
>  
> -		*base  = (csbase & GENMASK(5,  15)) << 6;
> -		*base |= (csbase & GENMASK(19, 30)) << 8;
> +		*base  = (csbase & GENMASK_ULL(15,  5)) << 6;
> +		*base |= (csbase & GENMASK_ULL(30, 19)) << 8;
>  
>  		*mask = ~0ULL;
>  		/* poke holes for the csmask */
> -		*mask &= ~((GENMASK(5, 15)  << 6) |
> -			   (GENMASK(19, 30) << 8));
> +		*mask &= ~((GENMASK_ULL(15, 5)  << 6) |
> +			   (GENMASK_ULL(30, 19) << 8));
>  
> -		*mask |= (csmask & GENMASK(5, 15))  << 6;
> -		*mask |= (csmask & GENMASK(19, 30)) << 8;
> +		*mask |= (csmask & GENMASK_ULL(15, 5))  << 6;
> +		*mask |= (csmask & GENMASK_ULL(30, 19)) << 8;
>  
>  		return;
>  	} else {
> @@ -370,9 +370,11 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
>  		addr_shift	= 8;
>  
>  		if (pvt->fam == 0x15)
> -			base_bits = mask_bits = GENMASK(19,30) | GENMASK(5,13);
> +			base_bits = mask_bits =
> +				GENMASK_ULL(30,19) | GENMASK_ULL(13,5);
>  		else
> -			base_bits = mask_bits = GENMASK(19,28) | GENMASK(5,13);
> +			base_bits = mask_bits =
> +				GENMASK_ULL(28,19) | GENMASK_ULL(13,5);
>  	}
>  
>  	*base  = (csbase & base_bits) << addr_shift;
> @@ -561,7 +563,7 @@ static u64 sys_addr_to_dram_addr(struct mem_ctl_info *mci, u64 sys_addr)
>  	 * section 3.4.2 of AMD publication 24592: AMD x86-64 Architecture
>  	 * Programmer's Manual Volume 1 Application Programming.
>  	 */
> -	dram_addr = (sys_addr & GENMASK(0, 39)) - dram_base;
> +	dram_addr = (sys_addr & GENMASK_ULL(39, 0)) - dram_base;
>  
>  	edac_dbg(2, "using DRAM Base register to translate SysAddr 0x%lx to DramAddr 0x%lx\n",
>  		 (unsigned long)sys_addr, (unsigned long)dram_addr);
> @@ -597,7 +599,7 @@ static u64 dram_addr_to_input_addr(struct mem_ctl_info *mci, u64 dram_addr)
>  	 * concerning translating a DramAddr to an InputAddr.
>  	 */
>  	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
> -	input_addr = ((dram_addr >> intlv_shift) & GENMASK(12, 35)) +
> +	input_addr = ((dram_addr >> intlv_shift) & GENMASK_ULL(35, 12)) +
>  		      (dram_addr & 0xfff);
>  
>  	edac_dbg(2, "  Intlv Shift=%d DramAddr=0x%lx maps to InputAddr=0x%lx\n",
> @@ -849,7 +851,7 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
>  		end_bit   = 39;
>  	}
>  
> -	addr = m->addr & GENMASK(start_bit, end_bit);
> +	addr = m->addr & GENMASK_ULL(end_bit, start_bit);
>  
>  	/*
>  	 * Erratum 637 workaround
> @@ -861,7 +863,7 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
>  		u16 mce_nid;
>  		u8 intlv_en;
>  
> -		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
> +		if ((addr & GENMASK_ULL(47, 24)) >> 24 != 0x00fdf7)
>  			return addr;
>  
>  		mce_nid	= amd_get_nb_id(m->extcpu);
> @@ -871,7 +873,7 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
>  		intlv_en = tmp >> 21 & 0x7;
>  
>  		/* add [47:27] + 3 trailing bits */
> -		cc6_base  = (tmp & GENMASK(0, 20)) << 3;
> +		cc6_base  = (tmp & GENMASK_ULL(20, 0)) << 3;
>  
>  		/* reverse and add DramIntlvEn */
>  		cc6_base |= intlv_en ^ 0x7;
> @@ -880,18 +882,18 @@ static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
>  		cc6_base <<= 24;
>  
>  		if (!intlv_en)
> -			return cc6_base | (addr & GENMASK(0, 23));
> +			return cc6_base | (addr & GENMASK_ULL(23, 0));
>  
>  		amd64_read_pci_cfg(pvt->F1, DRAM_LOCAL_NODE_BASE, &tmp);
>  
>  							/* faster log2 */
> -		tmp_addr  = (addr & GENMASK(12, 23)) << __fls(intlv_en + 1);
> +		tmp_addr  = (addr & GENMASK_ULL(23, 12)) << __fls(intlv_en + 1);
>  
>  		/* OR DramIntlvSel into bits [14:12] */
> -		tmp_addr |= (tmp & GENMASK(21, 23)) >> 9;
> +		tmp_addr |= (tmp & GENMASK_ULL(23, 21)) >> 9;
>  
>  		/* add remaining [11:0] bits from original MC4_ADDR */
> -		tmp_addr |= addr & GENMASK(0, 11);
> +		tmp_addr |= addr & GENMASK_ULL(11, 0);
>  
>  		return cc6_base | tmp_addr;
>  	}
> @@ -952,12 +954,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>  
>  	amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
>  
> -	pvt->ranges[range].lim.lo &= GENMASK(0, 15);
> +	pvt->ranges[range].lim.lo &= GENMASK_ULL(15, 0);
>  
>  				    /* {[39:27],111b} */
>  	pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
>  
> -	pvt->ranges[range].lim.hi &= GENMASK(0, 7);
> +	pvt->ranges[range].lim.hi &= GENMASK_ULL(7, 0);
>  
>  				    /* [47:40] */
>  	pvt->ranges[range].lim.hi |= llim >> 13;
> @@ -1330,7 +1332,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
>  			chan_off = dram_base;
>  	}
>  
> -	return (sys_addr & GENMASK(6,47)) - (chan_off & GENMASK(23,47));
> +	return (sys_addr & GENMASK_ULL(47,6)) - (chan_off & GENMASK_ULL(47,23));
>  }
>  
>  /*
> diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
> index d2443cf..6dc1fcc 100644
> --- a/drivers/edac/amd64_edac.h
> +++ b/drivers/edac/amd64_edac.h
> @@ -160,14 +160,6 @@
>  #define OFF false
>  
>  /*
> - * Create a contiguous bitmask starting at bit position @lo and ending at
> - * position @hi. For example
> - *
> - * GENMASK(21, 39) gives us the 64bit vector 0x000000ffffe00000.
> - */
> -#define GENMASK(lo, hi)			(((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))
> -
> -/*
>   * PCI-defined configuration space registers
>   */
>  #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
> diff --git a/drivers/video/sis/init.c b/drivers/video/sis/init.c
> index f082ae5..4f26bc2 100644
> --- a/drivers/video/sis/init.c
> +++ b/drivers/video/sis/init.c
> @@ -3320,9 +3320,8 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
>  }
>  
>  #ifndef GETBITSTR
> -#define BITMASK(h,l)    	(((unsigned)(1U << ((h)-(l)+1))-1)<<(l))
> -#define GENMASK(mask)   	BITMASK(1?mask,0?mask)
> -#define GETBITS(var,mask)   	(((var) & GENMASK(mask)) >> (0?mask))
> +#define GENBITSMASK(mask)   	GENMASK(1?mask,0?mask)
> +#define GETBITS(var,mask)   	(((var) & GENBITSMASK(mask)) >> (0?mask))
>  #define GETBITSTR(val,from,to)  ((GETBITS(val,from)) << (0?to))
>  #endif
>  
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index a3b6b82..bd0c459 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -10,6 +10,14 @@
>  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
>  #endif
>  
> +/*
> + * Create a contiguous bitmask starting at bit position @l and ending at
> + * position @h. For example
> + * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
> + */
> +#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
> +#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
> +
>  extern unsigned int __sw_hweight8(unsigned int w);
>  extern unsigned int __sw_hweight16(unsigned int w);
>  extern unsigned int __sw_hweight32(unsigned int w);


-- 

Cheers,
Mauro
