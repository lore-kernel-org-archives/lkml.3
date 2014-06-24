Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaFXHr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:47:57 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:38299 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424AbaFXHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:47:55 -0400
X-IronPort-AV: E=Sophos;i="5.00,767,1396972800"; 
   d="scan'208";a="32341006"
Message-ID: <53A92D50.3050507@cn.fujitsu.com>
Date: Tue, 24 Jun 2014 15:48:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tetra2005@gmail.com>,
        <preobr@google.com>, <dvyukov@google.com>, <kcc@google.com>,
        <koct9i@gmail.com>
Subject: Re: [PATCH] lib: idr: fix out-of-bounds pointer dereference
References: <1403530628-32306-1-git-send-email-a.ryabinin@samsung.com> <53A8D3B0.8090004@cn.fujitsu.com> <53A91125.8020203@samsung.com>
In-Reply-To: <53A91125.8020203@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


326cf0f0f308 ("idr: fix top layer handling") enlarged the pa array.
But the additional "+1" space is only used in id-allocation, it is free
in other usage, (paa may point to the additional "+1" space, but not dereference it).
so you can reuse it.

In the 3 functions your patch touched:
-	struct idr_layer ***paa = &pa[0];
+	struct idr_layer ***paa = &pa[1];


I don't reject your patch, I had review it.

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

The reason why I'm still muttering here is that I wish a simple solution
to fix the problem. And:
1) your patch also makes use of the additional "+1" @pa space: *++paa = p
2) your patch may slight enlarge the function body.
3) I think you patch reduces the readability a little although the idr code
   itself is already shit.
