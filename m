Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbaGBSeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:34:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:55538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaGBSd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,589,1400050800"; 
   d="scan'208";a="537898492"
Message-ID: <53B45095.80102@intel.com>
Date: Wed, 02 Jul 2014 11:33:57 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
References: <cover.1404245510.git.d.kasatkin@samsung.com> <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
In-Reply-To: <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 01:12 PM, Dmitry Kasatkin wrote:
> +	ima_ahash=	[IMA] Asynchronous hash usage parameters
> +			Format: <min_file_size>
> +			Set the minimal file size when use asynchronous hash.
> +			If ima_ahash is not provided, ahash usage is disabled.

<groan> ... another boot option...

Can we just set this to something sane, and then make a sysctl or
something else at runtime to tweak it?  The kernel won't use IMA much
before userspace comes up, and it can surely live with a slightly
suboptimal tuning until the boot scripts have a chance to go bang the
tunable.

We should reserve command-line parameters for things that really need
tweaking in early boot or are _needed_ to boot.
