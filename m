Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3FZHhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:37:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:43477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:37:23 -0400
Message-ID: <1372232238.8157.2.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] cfg80211/mac80211: fix doc compilation warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Jun 2013 09:37:18 +0200
In-Reply-To: <1372189700-6247-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1372189700-6247-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 21:48 +0200, Michael Opdenacker wrote:
> This patch fixes countless "No description found for parameter"
> warnings generating documentation (running "make htmldocs"),
> because the comments do not match the actual prototypes in the code.
> 
> This issue didn't exist in 3.9. It may we worth fixing in 3.10
> (if it's not too late).

I think it's way late. Besides, all of this is already fixed in -next
trees.


> @@ -4153,6 +4153,7 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
>   * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
>   *
>   * @wdev: the wireless device for which critical protocol is stopped.
> + * @gfp: the type of memory to allocate (see kmalloc).

This is also wrong, the allocation flags don't really change the *type*
of memory, but only *how* it is allocated.

johannes

