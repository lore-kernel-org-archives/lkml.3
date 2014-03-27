Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbaC0RRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:17:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19611 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaC0RRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:17:50 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-b8-53345d3cf498
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 1/2] clk: Add function parsing arbitrary clock list
 DT property
Date: Thu, 27 Mar 2014 18:17:27 +0100
Message-id: <3164460.aT5tTxdc17@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1395922579-28547-2-git-send-email-s.nawrocki@samsung.com>
References: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
 <1395922579-28547-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQV3bWJNgg+v3WC3mHznHatH/ZiGr
	xYE/OxgtmhevZ7M42/SG3WLT42usFpd3zWGzuH2Z12LtkbvsFkuvX2SyeDrhIptF694j7BaH
	37SzWsyY/JLNYv2M1ywO/B5r5q1h9Ghp7mHzuNzXy+SxaVUnm8eda3vYPPbPXcPusXlJvUff
	llWMHp83yQVwRnHZpKTmZJalFunbJXBlzOp6wFxwQbrixIPHzA2Ms8W6GDk5JARMJI40T2KF
	sMUkLtxbz9bFyMUhJDCdUeLh3AksEE4Lk0TP5c+MIFVsAlYSE9tXgdkiAvoSS1ZdBOtgFvjI
	JHHlxjPmLkYODmGBGImLx81BTBYBVYnLn5NBynkFNCV2ND8CWyYq4CmxY/tKNhCbU8Bd4snW
	D+wQu5oZJaZOv8UI0SAo8WPyPRYQm1lAXmLf/qmsELaOxP7WaWwTGAVmISmbhaRsFpKyBYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY+uZ1A7GlQ0WhxgFOBiVeHgdLEyChVgTy4or
	cw8xSnAwK4nwnowCCvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl
	4uCUamDk/Fi+dUtK+5WiNb/e6JcwsYT7LN3/6WfD0p9ZYic8TpnbLJY8dmBKUvyUq18s/QQi
	1t8vWeTr9cijbKZDTntQ3tsPgb/nyM4S0FXU62GUDpHe8f/6uReXt584qa3tWH7Ugevg4mV/
	ZspFXVf4+uCW0+eCG9xeNYxvd28T6WDXXdh3T8/PcWmLEktxRqKhFnNRcSIAafrjvakCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sylwester,

On Thursday, March 27, 2014 01:16:18 PM Sylwester Nawrocki wrote:
> The of_clk_get_by_property() function added by this patch is similar to
> of_clk_get(), except it allows to pass name of a DT property containing
> list of phandles and clock specifiers. For of_clk_get() this has been
> hard coded to "clocks".
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
> Changes since v2:
>  - moved the function declaration from drivers/clk/clk.h to
>    include/linux/clk.h
> 
> Changes since v1:
>  - s/of_clk_get_list_entry/of_clk_get_by_property.
> ---
>  drivers/clk/clkdev.c |   25 +++++++++++++++++++++----
>  include/linux/clk.h  |    7 +++++++
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index a360b2e..1d41540 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -27,17 +27,28 @@ static LIST_HEAD(clocks);
>  static DEFINE_MUTEX(clocks_mutex);
>  
>  #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
> -struct clk *of_clk_get(struct device_node *np, int index)
> +/**
> + * of_clk_get_by_property() - Parse and lookup a clock referenced by a device node
> + * @np: pointer to clock consumer node
> + * @list_name: name of the clock list property
> + * @index: index to the clock list
> + *
> + * This function parses the @list_name property and together with @index
> + * value indicating an entry of the list uses it to look up the struct clk
> + * from the registered list of clock providers.
> + */
> +struct clk *of_clk_get_by_property(struct device_node *np,
> +				   const char *list_name, int index)
>  {
>  	struct of_phandle_args clkspec;
>  	struct clk *clk;
>  	int rc;
>  
> -	if (index < 0)
> +	if (index < 0 || !list_name)
>  		return ERR_PTR(-EINVAL);
>  
> -	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
> -					&clkspec);
> +	rc = of_parse_phandle_with_args(np, list_name, "#clock-cells",
> +					index, &clkspec);
>  	if (rc)
>  		return ERR_PTR(rc);
>  
> @@ -51,6 +62,12 @@ struct clk *of_clk_get(struct device_node *np, int index)
>  	of_node_put(clkspec.np);
>  	return clk;
>  }
> +EXPORT_SYMBOL(of_clk_get_by_property);
> +
> +struct clk *of_clk_get(struct device_node *np, int index)
> +{
> +	return of_clk_get_by_property(np, "clocks", index);
> +}
>  EXPORT_SYMBOL(of_clk_get);
>  
>  /**
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 0dd9114..f71235b 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -383,6 +383,8 @@ struct of_phandle_args;
>  
>  #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>  struct clk *of_clk_get(struct device_node *np, int index);
> +struct clk *of_clk_get_by_property(struct device_node *np,
> +				   const char *list_name, int index);
>  struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
>  struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
>  #else
> @@ -395,6 +397,11 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
>  {
>  	return ERR_PTR(-ENOENT);
>  }
> +struct clk *of_clk_get_by_property(struct device_node *np,

This causes build brake with s3c6400_defconfig
(it should be 'static inline').

> +				   const char *list_name, int index)
> +{
> +	return ERR_PTR(-ENOENT);
> +}
>  #endif
>  
>  #endif

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

