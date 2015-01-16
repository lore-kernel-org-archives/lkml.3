Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbbAPUNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:13:40 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:42469 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbbAPUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <1421324819-8205-1-git-send-email-xiakaixu@huawei.com>
References: <1421324819-8205-1-git-send-email-xiakaixu@huawei.com>
Date: Fri, 16 Jan 2015 13:13:38 -0700
Message-ID: <CANLsYkzr28AwAP6eX4VZp-Uf5N_jJf2gmc-ks4KXwc3QEcCscg@mail.gmail.com>
Subject: Re: [PATCH] coresight: remove the unnecessary function coresight_is_bit_set()
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2015 at 05:26, Kaixu Xia <xiakaixu@huawei.com> wrote:
> This function coresight_is_bit_set() isn't called, so we should
> remove it.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  include/linux/coresight.h | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/include/linux/coresight.h b/include/linux/coresight.h
> index 5d3c543..a860933 100644
> --- a/include/linux/coresight.h
> +++ b/include/linux/coresight.h
> @@ -236,7 +236,6 @@ coresight_register(struct coresight_desc *desc);
>  extern void coresight_unregister(struct coresight_device *csdev);
>  extern int coresight_enable(struct coresight_device *csdev);
>  extern void coresight_disable(struct coresight_device *csdev);
> -extern int coresight_is_bit_set(u32 val, int position, int value);
>  extern int coresight_timeout(void __iomem *addr, u32 offset,
>                              int position, int value);
>  #ifdef CONFIG_OF
> @@ -250,8 +249,6 @@ static inline void coresight_unregister(struct coresight_device *csdev) {}
>  static inline int
>  coresight_enable(struct coresight_device *csdev) { return -ENOSYS; }
>  static inline void coresight_disable(struct coresight_device *csdev) {}
> -static inline int coresight_is_bit_set(u32 val, int position, int value)
> -                                        { return 0; }
>  static inline int coresight_timeout(void __iomem *addr, u32 offset,
>                                      int position, int value) { return 1; }
>  #ifdef CONFIG_OF
> --
> 1.8.5.5
>

Applied - thanks.
