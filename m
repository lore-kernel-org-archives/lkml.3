Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133Ab3CZH13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:27:29 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36766 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3CZH12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:27:28 -0400
MIME-Version: 1.0
In-Reply-To: <1364230583-4043-1-git-send-email-s.nawrocki@samsung.com>
References: <1364230583-4043-1-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 26 Mar 2013 15:27:27 +0800
Message-ID: <CAP1dx+y5GCtx2nnmzwEq20N0J24MYz3WbJgxW80CMHOCcWrS3A@mail.gmail.com>
Subject: Re: [PATCH] mfd: syscon: Add missing struct device_node declaration
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: sameo@linux.intel.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 00:56, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> syscon.h header uses struct device_node in functions' declarations
> without declaring it. This causes compilation warnings like:
>
> include/linux/mfd/syscon.h:20: warning: ‘struct device_node’
> declared inside parameter list
> include/linux/mfd/syscon.h:20: warning: its scope is only this
> definition or declaration, which is probably not what you want
>
> Fix it by adding a forward declaration of struct device_node.
>
> Cc: Dong Aisheng <dong.aisheng@linaro.org>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

> ---
>  include/linux/mfd/syscon.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
> index 6aeb6b8..f7be936 100644
> --- a/include/linux/mfd/syscon.h
> +++ b/include/linux/mfd/syscon.h
> @@ -15,6 +15,8 @@
>  #ifndef __LINUX_MFD_SYSCON_H__
>  #define __LINUX_MFD_SYSCON_H__
>
> +struct device_node;
> +
>  extern struct regmap *syscon_node_to_regmap(struct device_node *np);
>  extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
>  extern struct regmap *syscon_regmap_lookup_by_phandle(
> --
> 1.7.9.5
>
