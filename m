Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaFFNhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:37:50 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:65151 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaFFNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:37:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140606115918.4584.2306.sendpatchset@w520>
References: <20140606115909.4584.28612.sendpatchset@w520>
	<20140606115918.4584.2306.sendpatchset@w520>
Date: Fri, 6 Jun 2014 08:37:48 -0500
Message-ID: <CAL_JsqLgbi1SwL-QUxHWbpZRjdhyEuRGjXPR-sh6WkkGdCc0eA@mail.gmail.com>
Subject: Re: [PATCH 01/02] of: Add OF_ADDRESS=n stub for of_can_translate_address()
From: Rob Herring <robherring2@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 6:59 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> From: Magnus Damm <damm+renesas@opensource.se>
>
> Add a stub for the CONFIG_OF_ADDRESS=n case of
> of_translate_address(). The return value for the
> stub is false which is in sync with when the full
> version of the function does not support address
> translation. Added to allow removal of Kconfig
> dependency handling for CONFIG_OF_ADDRESS.

of_can_translate_address is gone in 3.16.

Rob

>
> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
> ---
>
>  include/linux/of_address.h |    5 +++++
>  1 file changed, 5 insertions(+)
>
> --- 0001/include/linux/of_address.h
> +++ work/include/linux/of_address.h     2014-06-06 19:04:44.000000000 +0900
> @@ -64,6 +64,11 @@ extern struct of_pci_range *of_pci_range
>                                         struct of_pci_range_parser *parser,
>                                         struct of_pci_range *range);
>  #else /* CONFIG_OF_ADDRESS */
> +static inline bool of_can_translate_address(struct device_node *dev)
> +{
> +       return false;
> +}
> +
>  static inline struct device_node *of_find_matching_node_by_address(
>                                         struct device_node *from,
>                                         const struct of_device_id *matches,
