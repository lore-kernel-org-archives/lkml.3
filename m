Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaKCWMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:12:07 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:33553 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaKCWME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:12:04 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: "Kani, Toshimitsu" <toshi.kani@hp.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        "yigal@plexistor.com" <yigal@plexistor.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: RE: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for WT
Thread-Topic: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for WT
Thread-Index: AQHP8juoXLRxtX3zhkeUJSzf2kRDYZxPgA5Q
Date: Mon, 3 Nov 2014 22:10:39 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593578ED@G9W0745.americas.hpqcorp.net>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com>
 <1414450545-14028-5-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1414450545-14028-5-git-send-email-toshi.kani@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Kani, Toshimitsu
> Sent: Monday, 27 October, 2014 5:56 PM
> To: hpa@zytor.com; tglx@linutronix.de; mingo@redhat.com; akpm@linux-
> foundation.org; arnd@arndb.de
> Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org;
> jgross@suse.com; stefan.bader@canonical.com; luto@amacapital.net;
> hmh@hmh.eng.br; yigal@plexistor.com; konrad.wilk@oracle.com; Kani,
> Toshimitsu
> Subject: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for
> WT
> 
> This patch adds pgprot_writethrough() for setting WT to a given
> pgprot_t.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
...
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index a214f5a..a0264d3 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -896,6 +896,16 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
>  }
>  EXPORT_SYMBOL_GPL(pgprot_writecombine);
> 
> +pgprot_t pgprot_writethrough(pgprot_t prot)
> +{
> +	if (pat_enabled)
> +		return __pgprot(pgprot_val(prot) |
> +				cachemode2protval(_PAGE_CACHE_MODE_WT));
> +	else
> +		return pgprot_noncached(prot);
> +}
> +EXPORT_SYMBOL_GPL(pgprot_writethrough);
...

Would you be willing to use EXPORT_SYMBOL for the new 
pgprot_writethrough function to provide more flexibility
for modules to utilize the new feature?  In x86/mm, 18 of 60
current exports are GPL and 42 are not GPL.

---
Rob Elliott    HP Server Storage


