Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaDKNvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaDKNvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:51:10 -0400
Date: Fri, 11 Apr 2014 15:50:27 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        dongxing.zhang@intel.com
Subject: Re: [PATCH] net: ipv4: current group_info should be put after using.
Message-ID: <20140411135027.GF15546@mguzik.redhat.com>
References: <1397271201.2575.4.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397271201.2575.4.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 10:53:21PM -0400, Wang, Xiaoming wrote:
> This is a typical refcount leak exploitable by unprivileged users.
> Current group_info had been got in ping_init_sock and
> group_info->usage increased. But the usage hasn't decreased
> anywhere in ping. This will make this group_info never freed.
> 

The patch is fine, however I had a brainfart with my last sentence about
commit message, sorry for that.

group_info *can be freed* by malicious user while still being pointed to
by something, that's the biggest problem with refcount leaks, therefore
this message needs some reworking.

I think that discussion about various consequences of refcount leak in
commit message is not necessary.

how about:

Plug a group_info refcount leak in ping_init.

group_info is only needed during initialization and the code failed to
release the reference on exit.

While here move grabbing the reference to a place where it is actually
needed.

====

Please cc: me if you resend the patch.

Thanks,
-- 
Mateusz Guzik
