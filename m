Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3JAFqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 01:46:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37790 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3JAFqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 01:46:51 -0400
Date: Tue, 1 Oct 2013 07:46:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, imtangchen@gmail.com
Subject: Re: [PATCH -mm] mm, memory-hotpulg: Rename movablenode boot option
 to movable_node
Message-ID: <20131001054646.GA17220@gmail.com>
References: <5249B7C6.7010902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249B7C6.7010902@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

> @@ -153,11 +153,18 @@ config MOVABLE_NODE
>  	help
>  	  Allow a node to have only movable memory.  Pages used by the kernel,
>  	  such as direct mapping pages cannot be migrated.  So the corresponding
> +	  memory device cannot be hotplugged.  This option allows the following
> +	  two things:
> +	  - When the system is booting, node full of hotpluggable memory can
> +	  be arranged to have only movable memory so that the whole node can
> +	  be hotplugged. (need movable_node boot option specified).

So this is _exactly_ what I complained about earlier: why is the 
movable_node boot option needed to get that extra functionality? It's 
clearly not just a drop-in substitute to CONFIG_MOVABLE_NODE but extends 
its functionality, right?

Boot options are _very_ poor user interface. If you don't want to enable 
it by default then turn this sub-functionality into 
CONFIG_MOVABLE_NODE_AUTO and keep it default-off - but don't pretend that 
this is only about CONFIG_MOVABLE_NODE alone - it isnt: as described above 
the 'movable_node' is needed for the full functionality to be available!

Thanks,

	Ingo
