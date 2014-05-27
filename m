Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaE0ANp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:13:45 -0400
Received: from mx11.pku.edu.cn ([162.105.129.174]:46136 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbaE0ANo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:13:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.405
Date: Tue, 27 May 2014 08:13:34 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <1549118231.23796.1401149614038.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <5383D647.9020508@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_1/3]_arch:_un?=
 =?utf-8?Q?icore32:_ksyms:_export_ad?=
 =?utf-8?Q?ditional_find=5Ffirst=5F*()_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Some modules need find_first_bit() and find_first_zero_bit(), so export
> them.
> 
> The related error (with allmodconfig under unicore32):
> 
>     MODPOST 4039 modules
>   ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
>   ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
>   ...
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

> ---
>  arch/unicore32/kernel/ksyms.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
> index e78911a..0323528 100644
> --- a/arch/unicore32/kernel/ksyms.c
> +++ b/arch/unicore32/kernel/ksyms.c
> @@ -23,6 +23,8 @@
>  
>  #include "ksyms.h"
>  
> +EXPORT_SYMBOL(find_first_bit);
> +EXPORT_SYMBOL(find_first_zero_bit);
>  EXPORT_SYMBOL(find_next_zero_bit);
>  EXPORT_SYMBOL(find_next_bit);
>  
> -- 
> 1.9.2.459.g68773ac

