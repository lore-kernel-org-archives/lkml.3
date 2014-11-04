Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaKDAWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:22:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56163 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750762AbaKDAWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:22:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <darren.hart@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] of: Fix overflow bug in string property parsing functions
Date: Tue, 04 Nov 2014 01:43:24 +0100
Message-ID: <4744029.MmARg0u2A0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415057904-6187-1-git-send-email-grant.likely@linaro.org>
References: <1415057904-6187-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 03, 2014 11:38:24 PM Grant Likely wrote:

[cut]

> diff --git a/include/linux/of.h b/include/linux/of.h
> index 6545e7aec7bb..3b3c6e849ae8 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -267,14 +267,12 @@ extern int of_property_read_u64(const struct device_node *np,
>  extern int of_property_read_string(struct device_node *np,
>  				   const char *propname,
>  				   const char **out_string);
> -extern int of_property_read_string_index(struct device_node *np,
> -					 const char *propname,
> -					 int index, const char **output);
>  extern int of_property_match_string(struct device_node *np,
>  				    const char *propname,
>  				    const char *string);
> -extern int of_property_count_strings(struct device_node *np,
> -				     const char *propname);
> +extern int of_property_read_string_helper(struct device_node *np,
> +					      const char *propname,
> +					      const char **out_strs, size_t sz, int index);
>  extern int of_device_is_compatible(const struct device_node *device,
>  				   const char *);
>  extern int of_device_is_available(const struct device_node *device);
> @@ -486,15 +484,9 @@ static inline int of_property_read_string(struct device_node *np,
>  	return -ENOSYS;
>  }
>  
> -static inline int of_property_read_string_index(struct device_node *np,
> -						const char *propname, int index,
> -						const char **out_string)
> -{
> -	return -ENOSYS;
> -}
> -
> -static inline int of_property_count_strings(struct device_node *np,
> -					    const char *propname)
> +static inline int of_property_read_string_helper(struct device_node *np,
> +						 const char *propname,
> +						 char **out_strs, size_t sz, int index)

	const char **out_strs, size_t sz, int index)

>  {
>  	return -ENOSYS;
>  }

Other than that, looks good to me.

Rafael

