Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaE0AOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:14:19 -0400
Received: from mx11.pku.edu.cn ([162.105.129.174]:43856 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751682AbaE0AOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:14:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.409
Date: Tue, 27 May 2014 08:14:07 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <1335905329.23803.1401149647833.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <5383D688.3080900@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_2/3]_arch:_?=
 =?utf-8?Q?unicore32:_ksyms:_expo?=
 =?utf-8?Q?rt_'pm=5Fpower=5Foff'_to_avoid_compiling_failure.?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Two driver modules need 'pm_power_off', so export it.
> 
> The related error (with allmodconfig under unicore32):
> 
>     MODPOST 4039 modules
>   ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
>   ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

> ---
>  arch/unicore32/kernel/process.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
> index 778ebba..b008e99 100644
> --- a/arch/unicore32/kernel/process.c
> +++ b/arch/unicore32/kernel/process.c
> @@ -60,6 +60,7 @@ void machine_halt(void)
>   * Function pointers to optional machine specific functions
>   */
>  void (*pm_power_off)(void) = NULL;
> +EXPORT_SYMBOL(pm_power_off);
>  
>  void machine_power_off(void)
>  {
> -- 
> 1.9.2.459.g68773ac

