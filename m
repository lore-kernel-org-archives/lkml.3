Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbbAVXOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:14:15 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60039 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbbAVXON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:14:13 -0500
MIME-Version: 1.0
In-Reply-To: <1421859957-24457-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1421859957-24457-1-git-send-email-pantelis.antoniou@konsulko.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 22 Jan 2015 17:13:51 -0600
Message-ID: <CAL_JsqKxtJH=JyruyuMLXSFfTLdswOLa=AfGEbROsSSOhLLDkg@mail.gmail.com>
Subject: Re: [PATCH] of: Empty node & property flag accessors when !OF
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Wolfram

On Wed, Jan 21, 2015 at 11:05 AM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Introduce empty node and property flag accessors when CONFIG_OF is not
> defined.
> This allows us to use them without ifdef'ing them in places where it
> makes sense to do so.
>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Acked-by: Rob Herring <robh@kernel.org>

I've asked Wolfram to apply. While not a fix itself, this is needed
for an I2C related fix for 3.19.

Rob

> ---
>  include/linux/of.h | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/include/linux/of.h b/include/linux/of.h
> index dfde07e..7ede449 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -616,6 +616,38 @@ static inline const char *of_prop_next_string(struct property *prop,
>         return NULL;
>  }
>
> +static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
> +{
> +       return 0;
> +}
> +
> +static inline int of_node_test_and_set_flag(struct device_node *n,
> +                                           unsigned long flag)
> +{
> +       return 0;
> +}
> +
> +static inline void of_node_set_flag(struct device_node *n, unsigned long flag)
> +{
> +}
> +
> +static inline void of_node_clear_flag(struct device_node *n, unsigned long flag)
> +{
> +}
> +
> +static inline int of_property_check_flag(struct property *p, unsigned long flag)
> +{
> +       return 0;
> +}
> +
> +static inline void of_property_set_flag(struct property *p, unsigned long flag)
> +{
> +}
> +
> +static inline void of_property_clear_flag(struct property *p, unsigned long flag)
> +{
> +}
> +
>  #define of_match_ptr(_ptr)     NULL
>  #define of_match_node(_matches, _node) NULL
>  #endif /* CONFIG_OF */
> --
> 1.7.12
>
