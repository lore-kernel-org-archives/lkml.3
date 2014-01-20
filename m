Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaATNjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:39:11 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56282 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaATNjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:39:08 -0500
Message-ID: <52DD26F1.20104@imgtec.com>
Date: Mon, 20 Jan 2014 13:38:57 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@driverdev.osuosl.org>, <andreas.dilger@intel.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <oleg.drokin@intel.com>, <jacques-charles.lafoucriere@cea.fr>,
        <jinshan.xiong@intel.com>, <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <52DA4E6A.1000308@gmail.com> <20140118100547.GS7444@mwanda> <52DA56C2.5010802@gmail.com> <20140118142404.GT7444@mwanda> <52DBA3D4.3090308@gmail.com> <52DD0EFF.2010305@imgtec.com> <20140120123045.GV7444@mwanda> <52DD18A5.1090308@imgtec.com> <20140120125603.GD4815@mwanda> <20140120130116.GW7444@mwanda>
In-Reply-To: <20140120130116.GW7444@mwanda>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_20_13_39_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/14 13:01, Dan Carpenter wrote:
> It would be easy enough to make the compiler complain about any union
> which would normally have size which is not a multiple of 4.
> 
> Warning: union will be padded with 2 bytes unless __attribute__((packed)).
> 
> Otherwise you will be fighting this for ever.

A good idea, but the problem is that most of the time it just doesn't
matter since all users of the data structure do so with the same ABI. We
already expect the compiler to take some liberties with padding and
alignment since the C standard permits it, so it's only when the exact
layout really matters (data structures dealing with hardware, stored to
disk, or passed over networks) that it ever becomes a problem.

> Are you sure it's padding the unions, and not just treating the unions
> as structs?

Yes

> What is the size of this union?
> 
> union a {
> 	int x;
> 	short y;
> };

4

Thanks
James

