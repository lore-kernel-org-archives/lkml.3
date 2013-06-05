Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3FEUTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:19:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:13931 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab3FEUTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,809,1363158000"; 
   d="scan'208";a="348795951"
Message-ID: <51AF9D40.60906@linux.intel.com>
Date: Wed, 05 Jun 2013 13:19:12 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "Fleming, Matt" <matt.fleming@intel.com>, joeyli <jlee@suse.com>,
        "rja@sgi.com" <rja@sgi.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com> <1370276021.30695.4.camel@linux-s257.site> <1370277079.6315.14.camel@x230.lan> <1370316933.30695.7.camel@linux-s257.site> <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com> <1370444007.6315.32.camel@x230.lan> <20130605155904.GC30420@console-pimps.org>
In-Reply-To: <20130605155904.GC30420@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 08:59 AM, Matt Fleming wrote:
> +		 * There still isn't enough room, so return an error
> +		 */
> +		if (remaining_size - size < 5120)
> +			return EFI_OUT_OF_RESOURCES;
> +	}

Please don't open-code the constant 5120 in this case.  We may easily
run into a system which needs, say, 7K, and it is error-prone to just
replace numbers.

	-hpa


