Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaHFKmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:42:25 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12960 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354AbaHFKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:42:23 -0400
X-IronPort-AV: E=Sophos;i="5.01,811,1400018400"; 
   d="scan'208";a="88461262"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Subject: [PATCH 0/1] delete unnecessary null test on array
Date: Wed,  6 Aug 2014 12:39:10 +0200
Message-Id: <1407321551-27479-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete NULL test on array.  The complete semantic patch that finds this
problem is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
type T;
T [] e;
position p;
@@

(
 e ==@p NULL
|
 e !=@p NULL
|
 !@p e
)

@ disable fld_to_ptr@
expression e;
identifier f;
position r.p;
@@

(
* (e.f) ==@p NULL
|
* (e.f) !=@p NULL
|
* !@p(e.f)
)
// </smpl>

For best results, this semantic patch requires lots of type information,
and should be used with the options --recursive-includes and
--relax-include-path.  This may take a long time to run.

