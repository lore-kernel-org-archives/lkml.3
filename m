Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaDRRO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:14:26 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57421 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaDRROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:14:24 -0400
Date: Fri, 18 Apr 2014 13:14:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 5/8] idr: covert BUG_ON() to WARN_ON_ONCE() if the
 argument is invalid.
Message-ID: <20140418171420.GD23576@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397825404-12039-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:49:52PM +0800, Lai Jiangshan wrote:
> @@ -1135,7 +1136,7 @@ void ida_simple_remove(struct ida *ida, unsigned int id)
>  {
>  	unsigned long flags;
>  
> -	BUG_ON((int)id < 0);
> +	WARN_ON_ONCE((int)id < 0);

Shouldn't this be moved to ida_remove()?  Also, it probably should
return afterwards?

Thanks.

-- 
tejun
