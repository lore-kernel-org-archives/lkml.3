Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaI2Upp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:45:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33949 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaI2Upo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:45:44 -0400
Date: Mon, 29 Sep 2014 16:45:41 -0400 (EDT)
Message-Id: <20140929.164541.20059477388052953.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: acme@ghostprotocols.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: llc: check for device before dereferencing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411782103-3059-1-git-send-email-sasha.levin@oracle.com>
References: <1411782103-3059-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 13:45:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Fri, 26 Sep 2014 21:41:43 -0400

> llc_ui_sendmsg would not make sure that a device indeed exists before
> dereferencing it. This caused a user triggerable NULL ptr deref:
...
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

The bug is real, but I don't think the fix is in the correct spot.

The real problem seems to be that the guard for calling
llc_ui_autobind() is inaccurate.

Fix that and there will always be a proper llc->dev attached at
this location.
