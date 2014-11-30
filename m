Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaK3STt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 13:19:49 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:8586 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbaK3STr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:19:47 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="91119165"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, sparmaintainer@unisys.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 0/4] remove unneeded array
Date: Sun, 30 Nov 2014 19:14:11 +0100
Message-Id: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an array or structure that only serves as the first argument to
memset.  The complete semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
type T;
@@

{
... when any
-T x[...];
<+... when != x
- memset(x,...);
...+>
}

@@
identifier x,i;
@@

{
... when any
-struct i x;
<+... when != x
- memset(&x,...);
...+>
}
// </smpl>

