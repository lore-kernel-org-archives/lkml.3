Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaGJJ4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:56:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:65150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaGJJ4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:56:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,637,1400050800"; 
   d="scan'208";a="455337991"
Message-ID: <1404986186.5102.98.camel@smile.fi.intel.com>
Subject: Re: [PATCH v1 5/5] [S390] zcrypt: use seq_hex_dump() to dump buffers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Jul 2014 12:56:26 +0300
In-Reply-To: <1404919470-26668-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-6-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 18:24 +0300, Andy Shevchenko wrote:
> Instead of custom approach let's use recently introduced seq_hex_dump() helper.
> 
> In this case it slightly changes the output, namely the four tetrads will be
> output on one line.

The above paragraph is not true and will be removed in v2.
The output is kept the same as in original code.

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/s390/crypto/zcrypt_api.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
> index 0e18c5d..d1f9983 100644
> --- a/drivers/s390/crypto/zcrypt_api.c
> +++ b/drivers/s390/crypto/zcrypt_api.c
> @@ -1203,16 +1203,8 @@ static void sprinthx(unsigned char *title, struct seq_file *m,
>  static void sprinthx4(unsigned char *title, struct seq_file *m,
>  		      unsigned int *array, unsigned int len)
>  {
> -	int r;
> -
>  	seq_printf(m, "\n%s\n", title);
> -	for (r = 0; r < len; r++) {
> -		if ((r % 8) == 0)
> -			seq_printf(m, "    ");
> -		seq_printf(m, "%08X ", array[r]);
> -		if ((r % 8) == 7)
> -			seq_putc(m, '\n');
> -	}
> +	seq_hex_dump(m, "    ", DUMP_PREFIX_NONE, 32, 4, array, len, false);
>  	seq_putc(m, '\n');
>  }
>  


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

