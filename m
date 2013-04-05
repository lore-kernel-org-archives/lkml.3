Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161674Ab3DEHSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:18:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54181 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab3DEHSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:18:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,413,1363104000"; 
   d="scan'208";a="7001469"
Message-ID: <515E7B77.7010807@cn.fujitsu.com>
Date: Fri, 05 Apr 2013 15:21:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/3] kernel/srcu: merge common code into a macro
References: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 15:17:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 15:17:38,
	Serialize complete at 2013/04/05 15:17:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/19/2013 10:16 PM, Sebastian Andrzej Siewior wrote:
> DEFINE_SRCU() and DEFINE_STATIC_SRCU() does the same thing except for
> the "static" attribute. This patch moves the common pieces into
> _DEFINE_SRCU() which is used by the the former macros either adding the
> static attribute or not.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  include/linux/srcu.h |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Hi, Sebastian

The patch hurts readability.
The original code are simple enough, merging them as one macro
gives us no benefit.

Thanks
Lai.


> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 6eb691b..d04acb8 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -102,13 +102,13 @@ void process_srcu(struct work_struct *work);
>   * define and init a srcu struct at build time.
>   * dont't call init_srcu_struct() nor cleanup_srcu_struct() on it.
>   */
> -#define DEFINE_SRCU(name)						\
> +#define _DEFINE_SRCU(name, mod)						\
>  	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
> -	struct srcu_struct name = __SRCU_STRUCT_INIT(name);
> +	mod struct srcu_struct name =					\
> +				__SRCU_STRUCT_INIT(name);
>  
> -#define DEFINE_STATIC_SRCU(name)					\
> -	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
> -	static struct srcu_struct name = __SRCU_STRUCT_INIT(name);
> +#define DEFINE_SRCU(name)		_DEFINE_SRCU(name, )
> +#define DEFINE_STATIC_SRCU(name)	_DEFINE_SRCU(name, static)
>  
>  /**
>   * call_srcu() - Queue a callback for invocation after an SRCU grace period

