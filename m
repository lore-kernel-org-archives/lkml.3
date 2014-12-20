Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaLTAYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:24:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLTAYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:24:43 -0500
Date: Sat, 20 Dec 2014 01:24:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH V3 08/11] power: charger-manager: Make chraging decision
 focusing on battery status.
Message-ID: <20141220002440.GC1694@amd>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
 <1418979323-7188-9-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418979323-7188-9-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: charging.


> In cm_monitor() where charging management starts, it checks various charging
> condition sequentially to decide next charging operation. However, as it

conditions.

> follows sequential process, cascaded IF statements, it does some duplicated
> jobs which is already done in previous stage. It results delay in decision

which are. It results in delay in the decision....?

> Both of problems mentioned above becomes clean if it manages battery charging

"become clear".


> @@ -249,6 +249,19 @@ static bool is_full_charged(struct charger_manager *cm)
>  	if (!fuel_gauge)
>  		return false;
>  
> +	/* Full, if it's over the fullbatt voltage */
> +	if (desc->fullbatt_uV > 0) {
> +		ret = get_batt_uV(cm, &uV);
> +		if (!ret) {
> +			/* Battery is already full, checks voltage drop. */

"check"

> --- a/include/linux/power/charger-manager.h
> +++ b/include/linux/power/charger-manager.h
> @@ -220,6 +220,7 @@ struct charger_desc {
>   *	saved status of battery before entering suspend-to-RAM
>   * @charging_start_time: saved start time of enabling charging
>   * @charging_end_time: saved end time of disabling charging
> + * @battery_status: Current battery status

"current" for consistency.

>   */
>  struct charger_manager {
>  	struct list_head entry;
> @@ -237,6 +238,8 @@ struct charger_manager {
>  
>  	u64 charging_start_time;
>  	u64 charging_end_time;
> +
> +	int battery_status;
>  };

Should battery_status be some kind of enum?
									Pavel
--						
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
