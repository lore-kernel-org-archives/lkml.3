Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaI1Bts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 21:49:48 -0400
Received: from mx11.pku.edu.cn ([162.105.129.174]:39611 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbaI1Btr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 21:49:47 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.41
Date: Sun, 28 Sep 2014 09:49:29 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>
Message-ID: <1373895763.5110.1411868969556.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1411586033.19525.34.camel@x220>
Subject: =?gbk?B?UmU6IFtQQVRDSF0gdW5pY29yZTMyOiBSZW1vdmUgdW5uZWVkZWQgS2NvbmZpZyBlbnRyeSBOT19JT1BPUlRfTUFQ?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late reply.

I checked this config, and it's only used for HAS_IOPORT_MAP in lib/Kconfig
Sure, removing it means no different for .config file.
I think a better way is reserving it or moving it into arch/Kconfig

Cc: linux-arch@vger.kernel.org

Xuetao Guan

----- Paul Bolle <pebolle@tiscali.nl> 写道：
> Architectures only need a Kconfig entry for NO_IOPORT_MAP if it is
> possible that its value will be 'y'. For unicore32 its value will always
> be 'n', making it pointless. Remove it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested by playing with arch/unicore32/configs/unicore32_defconfig. This
> patch made no difference whatsoever to the generated .config file.
> Please note that it has
>     CONFIG_HAS_IOPORT_MAP=y
> 
> set after invoking "make oldconfig" both before and after this patch.
> 
>  arch/unicore32/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index 928237a7b9ca..2322cc87e7cb 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -27,9 +27,6 @@ config UNICORE32
>  config GENERIC_CSUM
>  	def_bool y
>  
> -config NO_IOPORT_MAP
> -	bool
> -
>  config STACKTRACE_SUPPORT
>  	def_bool y
>  
> -- 
> 1.9.3
> 

