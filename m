Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaIAQJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:09:16 -0400
Received: from mail1.windriver.com ([147.11.146.13]:34958 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaIAQJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:09:15 -0400
Date: Mon, 1 Sep 2014 12:08:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <eparis@redhat.com>, <paulmck@linux.vnet.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, <zhenglong.cai@cs2c.com.cn>,
        <khilman@linaro.org>, <ak@linux.intel.com>, <mcgrof@suse.com>,
        <fabf@skynet.be>, "dhowells@redhat.com" <dhowells@redhat.com>,
        <pefoley2@pefoley.com>, <mgorman@suse.de>, <biederm@xmission.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] init/Kconfig: Add ENDIAN attributes for all
 architectures using
Message-ID: <20140901160828.GJ26632@windriver.com>
References: <540494D6.40701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <540494D6.40701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH] init/Kconfig: Add ENDIAN attributes for all architectures using] On 01/09/2014 (Mon 23:46) Chen Gang wrote:

> Some individual modules want to know the architecture's endian attribute
> during config time, or may cause compiling break, one sample is below:
> (with allm dconfig under microblaze):
> 
>     CC [M]  drivers/isdn/hisax/nj_s.o
>   drivers/isdn/hisax/nj_s.c: In function 'setup_netjet_s':
>   drivers/isdn/hisax/nj_s.c:265:2: error: #error "not running on big endian machines now"
>    #error "not running on big endian machines now"
> 
> So add endian attributes for all architectures using (next, will let all
> architectures choose their endians during config time).
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  init/Kconfig | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index ac033c3..f301cc8 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -23,6 +23,12 @@ config CONSTRUCTORS
>  config IRQ_WORK
>  	bool
>  
> +config CPU_LITTLE_ENDIAN
> +	bool
> +
> +config CPU_BIG_ENDIAN
> +	bool

Perhaps you should take a cursory look at what already exists in tree
before blindly trying to add more to it?

$ git grep CPU_BIG_ENDIAN | wc -l
88

Paul.
--

> +
>  config BUILDTIME_EXTABLE_SORT
>  	bool
>  
> -- 
> 1.7.11.7
