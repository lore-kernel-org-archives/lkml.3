Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaC1Si2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:38:28 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49406 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaC1SiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:38:25 -0400
Date: Fri, 28 Mar 2014 11:38:36 -0700
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        rob.herring@linaro.org
Subject: Re: [RFC 2/5] of: Create of_console_check() for selecting a console
 specified in /chosen
Message-ID: <20140328183836.GA25241@quad.lixom.net>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
 <1396022885-6102-3-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396022885-6102-3-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 28, 2014 at 09:08:02AM -0700, Grant Likely wrote:
> The devicetree has a binding for specifying the console device in the
> /chosen node, but the kernel doesn't use it consistently. This change
> adds an API for testing if a device node is a console, and adds a
> preferred console entry if it is.
> 
> At the same time this patch removes the of_device_is_stdout_path() API
> since it is unused.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/of/base.c  | 23 +++++++++++++----------
>  include/linux/of.h |  6 +++---
>  2 files changed, 16 insertions(+), 13 deletions(-)

[...]

> diff --git a/include/linux/of.h b/include/linux/of.h
> index a8b9dad90c64..417945ebd8e1 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -343,7 +343,7 @@ const __be32 *of_prop_next_u32(struct property *prop, const __be32 *cur,
>   */
>  const char *of_prop_next_string(struct property *prop, const char *cur);
>  
> -int of_device_is_stdout_path(struct device_node *dn);
> +bool of_console_check(struct device_node *dn, char *name, int index);
>  
>  #else /* CONFIG_OF */
>  
> @@ -544,9 +544,9 @@ static inline int of_machine_is_compatible(const char *compat)
>  	return 0;
>  }
>  
> -static inline int of_device_is_stdout_path(struct device_node *dn)
> +static bool of_console_check(const struct device_node *dn, const char *name, int index)

static inline or you'll get warnings about unused functions.


-Olof
