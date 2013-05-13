Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3EMIRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:17:18 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:38747 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3EMIRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:17:16 -0400
Date: Mon, 13 May 2013 10:17:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a
 minimum duration
Message-ID: <20130513101707.53259093@endymion.delvare>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW...

On Fri, 10 May 2013 15:13:19 +0300, Imre Deak wrote:
> +#define __define_time_to_jiffies_min(tname, ttype)			\
> +static inline unsigned long						\
> +tname ## _to_jiffies_min(const ttype m)					\
> +{									\
> +	return max_t(long, MAX_JIFFY_OFFSET, tname ## _to_jiffies(m) + 1);\
> +}

How would this work at all? Isn't it going to just return
MAX_JIFFY_OFFSET all the time?

-- 
Jean Delvare
