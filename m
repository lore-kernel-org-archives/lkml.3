Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbbAMOQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:16:53 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50211 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbAMOQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:16:51 -0500
X-IronPort-AV: E=McAfee;i="5600,1067,7679"; a="82214467"
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="32123504"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 8/8] ath10k: fix error return code
References: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
	<1419872683-32709-9-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 13 Jan 2015 16:16:40 +0200
In-Reply-To: <1419872683-32709-9-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Mon, 29 Dec 2014 18:04:43 +0100")
Message-ID: <87ppai6a0n.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: NASANEXM01C.na.qualcomm.com (10.85.0.83) To
 NALASEXR01G.na.qualcomm.com (10.49.56.53)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> Return a negative error code on failure.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier ret; expression e1,e2;
> @@
> (
> if (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, applied to ath.git.

-- 
Kalle Valo
