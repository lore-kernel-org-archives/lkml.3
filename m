Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaE0J0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:26:40 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:62001 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaE0J0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:26:39 -0400
Date: Tue, 27 May 2014 10:26:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, joe@perches.com
Subject: Re: [PATCH] regulator: Constify the pointer to alias name array
Message-ID: <20140527092633.GI5875@lee--X1>
References: <1400859850-24505-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400859850-24505-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Joe, I left you off this one by mistake.

This has now been applied by Mark.

> Toughen-up checks for read-only regulator names.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/regulator/core.c           |  7 ++++---
>  drivers/regulator/devres.c         |  6 +++---
>  include/linux/mfd/core.h           |  2 +-
>  include/linux/regulator/consumer.h | 36 ++++++++++++++++++++----------------
>  4 files changed, 28 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 9a09f3c..ba28d29 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1597,9 +1597,10 @@ EXPORT_SYMBOL_GPL(regulator_unregister_supply_alias);
>   * registered any aliases that were registered will be removed
>   * before returning to the caller.
>   */
> -int regulator_bulk_register_supply_alias(struct device *dev, const char **id,
> +int regulator_bulk_register_supply_alias(struct device *dev,
> +					 const char *const *id,
>  					 struct device *alias_dev,
> -					 const char **alias_id,
> +					 const char *const *alias_id,
>  					 int num_id)
>  {
>  	int i;
> @@ -1637,7 +1638,7 @@ EXPORT_SYMBOL_GPL(regulator_bulk_register_supply_alias);
>   * aliases in one operation.
>   */
>  void regulator_bulk_unregister_supply_alias(struct device *dev,
> -					    const char **id,
> +					    const char *const *id,
>  					    int num_id)
>  {
>  	int i;
> diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
> index f44818b..8f785bc 100644
> --- a/drivers/regulator/devres.c
> +++ b/drivers/regulator/devres.c
> @@ -360,9 +360,9 @@ EXPORT_SYMBOL_GPL(devm_regulator_unregister_supply_alias);
>   * will be removed before returning to the caller.
>   */
>  int devm_regulator_bulk_register_supply_alias(struct device *dev,
> -					      const char **id,
> +					      const char *const *id,
>  					      struct device *alias_dev,
> -					      const char **alias_id,
> +					      const char *const *alias_id,
>  					      int num_id)
>  {
>  	int i;
> @@ -404,7 +404,7 @@ EXPORT_SYMBOL_GPL(devm_regulator_bulk_register_supply_alias);
>   * will ensure that the resource is freed.
>   */
>  void devm_regulator_bulk_unregister_supply_alias(struct device *dev,
> -						 const char **id,
> +						 const char *const *id,
>  						 int num_id)
>  {
>  	int i;
> diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> index bdba8c6..f543de9 100644
> --- a/include/linux/mfd/core.h
> +++ b/include/linux/mfd/core.h
> @@ -63,7 +63,7 @@ struct mfd_cell {
>  	/* A list of regulator supplies that should be mapped to the MFD
>  	 * device rather than the child device when requested
>  	 */
> -	const char		**parent_supplies;
> +	const char * const	*parent_supplies;
>  	int			num_parent_supplies;
>  };
>  
> diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
> index 1a4a8c1..ccd3d77 100644
> --- a/include/linux/regulator/consumer.h
> +++ b/include/linux/regulator/consumer.h
> @@ -151,11 +151,13 @@ int regulator_register_supply_alias(struct device *dev, const char *id,
>  				    const char *alias_id);
>  void regulator_unregister_supply_alias(struct device *dev, const char *id);
>  
> -int regulator_bulk_register_supply_alias(struct device *dev, const char **id,
> +int regulator_bulk_register_supply_alias(struct device *dev,
> +					 const char *const *id,
>  					 struct device *alias_dev,
> -					 const char **alias_id, int num_id);
> +					 const char *const *alias_id,
> +					 int num_id);
>  void regulator_bulk_unregister_supply_alias(struct device *dev,
> -					    const char **id, int num_id);
> +					    const char * const *id, int num_id);
>  
>  int devm_regulator_register_supply_alias(struct device *dev, const char *id,
>  					 struct device *alias_dev,
> @@ -164,12 +166,12 @@ void devm_regulator_unregister_supply_alias(struct device *dev,
>  					    const char *id);
>  
>  int devm_regulator_bulk_register_supply_alias(struct device *dev,
> -					      const char **id,
> +					      const char *const *id,
>  					      struct device *alias_dev,
> -					      const char **alias_id,
> +					      const char *const *alias_id,
>  					      int num_id);
>  void devm_regulator_bulk_unregister_supply_alias(struct device *dev,
> -						 const char **id,
> +						 const char *const *id,
>  						 int num_id);
>  
>  /* regulator output control and status */
> @@ -290,17 +292,17 @@ static inline void regulator_unregister_supply_alias(struct device *dev,
>  }
>  
>  static inline int regulator_bulk_register_supply_alias(struct device *dev,
> -						       const char **id,
> -						       struct device *alias_dev,
> -						       const char **alias_id,
> -						       int num_id)
> +						const char *const *id,
> +						struct device *alias_dev,
> +						const char * const *alias_id,
> +						int num_id)
>  {
>  	return 0;
>  }
>  
>  static inline void regulator_bulk_unregister_supply_alias(struct device *dev,
> -							  const char **id,
> -							  int num_id)
> +						const char * const *id,
> +						int num_id)
>  {
>  }
>  
> @@ -317,15 +319,17 @@ static inline void devm_regulator_unregister_supply_alias(struct device *dev,
>  {
>  }
>  
> -static inline int devm_regulator_bulk_register_supply_alias(
> -		struct device *dev, const char **id, struct device *alias_dev,
> -		const char **alias_id, int num_id)
> +static inline int devm_regulator_bulk_register_supply_alias(struct device *dev,
> +						const char *const *id,
> +						struct device *alias_dev,
> +						const char *const *alias_id,
> +						int num_id)
>  {
>  	return 0;
>  }
>  
>  static inline void devm_regulator_bulk_unregister_supply_alias(
> -		struct device *dev, const char **id, int num_id)
> +	struct device *dev, const char *const *id, int num_id)
>  {
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
