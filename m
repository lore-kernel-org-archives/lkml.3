Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaATDtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:49:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41008 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATDs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:48:59 -0500
Date: Sun, 19 Jan 2014 19:48:56 -0800 (PST)
Message-Id: <20140119.194856.491294439635992592.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH net] tun: handle copy failure in tun_put_user()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390187808-5462-1-git-send-email-jasowang@redhat.com>
References: <1390187808-5462-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 20 Jan 2014 11:16:48 +0800

> This patch return the error code of copy helpers in tun_put_user() instead of
> ignoring them.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

If you perform some of the copy successfully, you have to report that
length rather than just an error.

Otherwise userland has no way to determine how much of the data was
successfully sourced.

I'm not applying this, sorry.
