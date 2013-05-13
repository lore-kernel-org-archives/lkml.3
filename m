Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3EMMB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:01:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:62901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab3EMMBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:01:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="333210125"
Message-ID: <1368446463.16445.90.camel@intelbox>
Subject: Re: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a
 minimum duration
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Date: Mon, 13 May 2013 15:01:03 +0300
In-Reply-To: <20130513101707.53259093@endymion.delvare>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	 <20130513101707.53259093@endymion.delvare>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 10:17 +0200, Jean Delvare wrote:
> BTW...
> 
> On Fri, 10 May 2013 15:13:19 +0300, Imre Deak wrote:
> > +#define __define_time_to_jiffies_min(tname, ttype)			\
> > +static inline unsigned long						\
> > +tname ## _to_jiffies_min(const ttype m)					\
> > +{									\
> > +	return max_t(long, MAX_JIFFY_OFFSET, tname ## _to_jiffies(m) + 1);\
> > +}
> 
> How would this work at all? Isn't it going to just return
> MAX_JIFFY_OFFSET all the time?

Yes, that's a mistake, I meant here min_t.

--Imre


