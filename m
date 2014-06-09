Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaFILLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:11:31 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:56885 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933373AbaFILLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:11:20 -0400
X-Yandex-Uniq: 746fd4ee-aab1-44a3-91fa-513d2dee7179
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 9 Jun 2014 15:11:15 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: viresh.kumar@linaro.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, stuart.w.hayes@gmail.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimers: conditionally lock/unlock spinlock in
 hrtimer_get_next_event
Message-ID: <20140609111115.GK26511@stfomichev-desktop.yandex.net>
References: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.10.1406091304140.3830@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406091304140.3830@nanos>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's wrong with simply doing:
> 
>        if (!hrtimer_hres_active())
>        	  return mindelta;
Nothing wrong, just makes diff bigger :-)

> That saves and indentation level and makes the code more
> readable. Also the lockless check wants a comment why it is correct.
Ok, I'll follow with updated patch.
