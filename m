Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbbAWOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:25:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:36903 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbbAWOZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:25:21 -0500
Date: Fri, 23 Jan 2015 15:24:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: WANG Chao <chaowang@redhat.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Borislav Petkov <bp@suse.de>, Daniel Kiper <daniel.kiper@oracle.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: add macro for_each_setup_data()
In-Reply-To: <1420628150-16872-2-git-send-email-chaowang@redhat.com>
Message-ID: <alpine.DEB.2.11.1501231502350.5526@nanos>
References: <1420628150-16872-1-git-send-email-chaowang@redhat.com> <1420628150-16872-2-git-send-email-chaowang@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, WANG Chao wrote:
  
> +#define for_each_setup_data(pa_data, data) \
> +	for (pa_data = boot_params.hdr.setup_data; \
> +		pa_data && (data = early_memremap(pa_data, sizeof(*data))); \
> +		pa_data = data->next, early_iounmap(data, sizeof(*data)))
> +

That makes the code obfuscated not clearer. Brain went into spiral
mode.

struct setup_iter {
       u64 pa_data, pa_next;
       u32 len, type;
};

....
{
     struct setup_iter iter = { .pa_next = boot_params.hdr.setup_data };

     while (get_next_setup_data(&iter)) {
     	   switch (iter.type) {
	   case SETUP_E820_EXT:
	      	 parse_e820_ext(iter.pa_data, iter.len);  	  
....

Perhaps?

Thanks,

	tglx
