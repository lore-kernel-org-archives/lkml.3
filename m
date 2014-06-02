Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaFBL6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:58:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52993 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754519AbaFBL6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:58:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        edubezval@gmail.com, pavel@ucw.cz, lgirdwood@gmail.com,
        broonie@kernel.org
Subject: Re: [PATCH V2 1/3] regulator: return -EINVAL from regulator_set_voltage() for !CONFIG_REGULATOR
Date: Mon, 02 Jun 2014 14:15:58 +0200
Message-ID: <5936444.Yl1Pz41PpD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <788accde56086078d69d3eba0d913114315de43a.1401693980.git.viresh.kumar@linaro.org>
References: <788accde56086078d69d3eba0d913114315de43a.1401693980.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 02, 2014 12:59:23 PM Viresh Kumar wrote:
> Currently regulator_set_voltage() returns zero when support for regulators isn't
> present in kernel, i.e. CONFIG_REGULATOR=n.
> 
> Make it return -EINVAL to propagate error instead of success here.
> Audit of all users of this routine is done to make sure nothing breaks due to
> this change.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Well, I'd say this patch series is for Mark and I'm fine with patch [3/3].

Thanks!

> ---
> V1->V2: - New patch as suggested by Mark.
> 
>  include/linux/regulator/consumer.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
> index 1a4a8c1..28fa089 100644
> --- a/include/linux/regulator/consumer.h
> +++ b/include/linux/regulator/consumer.h
> @@ -394,7 +394,7 @@ static inline void regulator_bulk_free(int num_consumers,
>  static inline int regulator_set_voltage(struct regulator *regulator,
>  					int min_uV, int max_uV)
>  {
> -	return 0;
> +	return -EINVAL;
>  }
>  
>  static inline int regulator_get_voltage(struct regulator *regulator)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
