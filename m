Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbaCFBqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:46:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51757 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659AbaCFBqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:46:03 -0500
Date: Wed, 05 Mar 2014 20:46:01 -0500 (EST)
Message-Id: <20140305.204601.621108199680054921.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, fwestpha@redhat.com
Subject: Re: [PATCH] bridge: multicast: add sanity check for query source
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393901855-18231-1-git-send-email-linus.luessing@web.de>
References: <1393901855-18231-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Mar 2014 17:46:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Tue,  4 Mar 2014 03:57:35 +0100

> MLD queries are supposed to have an IPv6 link-local source address
> according to RFC2710, section 4 and RFC3810, section 5.1.14. This patch
> adds a sanity check to ignore such broken MLD queries.
> 
> Without this check, such malformed MLD queries can result in a
> denial of service: The queries are ignored by any MLD listener
> therefore they will not respond with an MLD report. However,
> without this patch these malformed MLD queries would enable the
> snooping part in the bridge code, potentially shutting down the
> according ports towards these hosts for multicast traffic as the
> bridge did not learn about these listeners.
> 
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Applied.
