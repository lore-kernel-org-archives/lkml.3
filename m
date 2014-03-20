Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbaCTO66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:58:58 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:14249 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542AbaCTO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:58:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,695,1389772800"; 
   d="scan'208";a="20700802"
Message-ID: <532B022C.8010505@broadcom.com>
Date: Thu, 20 Mar 2014 15:58:52 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Monam Agarwal <monamagarwal123@gmail.com>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eddie.wai@broadcom.com>,
        <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/9] Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,NULL)
References: <cover.1395324808.git.monamagarwal123@gmail.com>
In-Reply-To: <cover.1395324808.git.monamagarwal123@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/14 15:37, Monam Agarwal wrote:
> This patchset uses following coccinelle script to replace
> rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,NULL)
>
> @@
> expression E;
> @@
> - rcu_assign_pointer(
> + RCU_INIT_POINTER(
> E, NULL)

I am not very familiar with rcu functionality nor coccinelle, but it 
looks too generic. I would think only NULL assignments during 
initialization should use RCU_INIT_POINTER(). The first patch in the 
series does it in a function called unregister_...(). Is it really ok to 
do there?

Gr. AvS

