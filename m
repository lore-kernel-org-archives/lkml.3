Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaGICkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:40:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55944 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaGICkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:40:23 -0400
Date: Tue, 08 Jul 2014 19:40:21 -0700 (PDT)
Message-Id: <20140708.194021.617273242591768642.davem@davemloft.net>
To: andrey.krieger.utkin@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, acme@ghostprotocols.net,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] appletalk: Fix socket referencing in skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404764570-24120-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1404764570-24120-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 19:40:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Date: Mon,  7 Jul 2014 23:22:50 +0300

> Setting just skb->sk without taking its reference and setting a
> destructor is invalid. However, in the places where this was done, skb
> is used in a way not requiring skb->sk setting. So dropping the setting
> of skb->sk.
> Thanks to Eric Dumazet <eric.dumazet@gmail.com> for correct solution.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79441
> Reported-by: Ed Martin <edman007@edman007.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Applied and queued up for -stable.
