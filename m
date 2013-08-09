Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031394Ab3HIWeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:34:07 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48064 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031364Ab3HIWeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:34:06 -0400
Date: Fri, 9 Aug 2013 15:29:31 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] power_supply: add throttle state
Message-ID: <20130809222931.GJ12638@lizard.sbx05730.santaca.wayport.net>
References: <1373823495-2651-1-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1373823495-2651-1-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 11:08:15PM +0530, Jenny TC wrote:
> The charger and battery temperature contribute to the
> platform thermal. The only way to control the temperature
> is to control the charging. The charging can be controlled in different
> way. This could be disabling charger, disabling charging, adjusting CC,
> or by adjusting the INLMT. This patch adds a structure to define the
> charger throttle actions. Also this patch adds a throttle_states
> field to the struct power_supply which can be used by the charger
> driver to define it's throttle actions for different states
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---

The code itself is OK. But for this and the previous patches I'd like to
see at least one user before merging it, i.e. I'd like to see how things
actually interact...

>  include/linux/power_supply.h |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 5a24e10..516e4c4 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -209,6 +209,18 @@ union power_supply_propval {
>  
>  struct device_node;
>  
> +enum psy_throttle_action {
> +

Stray empty line here.

> +	PSY_THROTTLE_DISABLE_CHARGER = 0,
> +	PSY_THROTTLE_DISABLE_CHARGING,
> +	PSY_THROTTLE_CC_LIMIT,

CHG_CUR?

> +	PSY_THROTTLE_INPUT_LIMIT,
> +};
> +
> +struct psy_throttle_state {
> +	enum psy_throttle_action throttle_action;
> +	unsigned throttle_val;
> +};

Missing empty line here.

>  struct power_supply {
>  	const char *name;
>  	enum power_supply_type type;
> @@ -223,6 +235,9 @@ struct power_supply {
>  	size_t num_supplies;
>  	struct device_node *of_node;
>  
> +	struct psy_throttle_state *throttle_states;
> +	size_t num_throttle_states;
> +
>  	int (*get_property)(struct power_supply *psy,
>  			    enum power_supply_property psp,
>  			    union power_supply_propval *val);
> -- 
> 1.7.9.5
