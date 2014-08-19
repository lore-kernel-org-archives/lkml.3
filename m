Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaHSNSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:18:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:14302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaHSNSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="374245051"
From: Andi Kleen <andi@firstfloor.org>
To: Bertrand Jacquin <beber@meleeweb.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 2/3] kbuild: handle module compression while running 'make modules_install'.
References: <1408215016-1848-1-git-send-email-beber@meleeweb.net>
	<1408215016-1848-3-git-send-email-beber@meleeweb.net>
Date: Tue, 19 Aug 2014 06:17:58 -0700
In-Reply-To: <1408215016-1848-3-git-send-email-beber@meleeweb.net> (Bertrand
	Jacquin's message of "Sat, 16 Aug 2014 20:50:15 +0200")
Message-ID: <87lhqkmxdl.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bertrand Jacquin <beber@meleeweb.net> writes:
>  
> +# CONFIG_MODULE_COMPRESS, if defined, will cause module to be compressed
> +# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP
> +# or CONFIG_MODULE_COMPRESS_XZ.
> +
> +mod_compress_cmd = true
> +ifdef CONFIG_MODULE_COMPRESS
> +  ifdef CONFIG_MODULE_COMPRESS_GZIP
> +    mod_compress_cmd = gzip -n -9

Please don't use gzip -9. The gain is very small, but it can make
the time to compress much longer. Just use plain gzip.

I suspect it doesn't make sense either for xz.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
