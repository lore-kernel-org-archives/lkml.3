Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaHTFYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:24:23 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:45728 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaHTFYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:24:22 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Ryan Mallon <rmallon@gmail.com>, "cpw@sgi.com" <cpw@sgi.com>,
        "robinmholt@gmail.com" <robinmholt@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] sgi-xp: Do not use BUG_ON(!spin_is_locked())
Thread-Topic: [PATCH] sgi-xp: Do not use BUG_ON(!spin_is_locked())
Thread-Index: AQHPtf4lJXQbMD9/qkm53pF2okgYeZvYhxCAgAB6qpA=
Date: Wed, 20 Aug 2014 05:24:19 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2FF3D@EU-MBX-02.mgc.mentorg.com>
References: <1407828913-7461-1-git-send-email-sanjeev_sharma@mentor.com>
 <53F3D7F3.3080900@gmail.com>
In-Reply-To: <53F3D7F3.3080900@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 20 Aug 2014 05:24:21.0519 (UTC) FILETIME=[FF5721F0:01CFBC36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opps ! Thanks for review comment. Just sent V2 updated patch.

Sanjeev Sharma

-----Original Message-----
From: Ryan Mallon [mailto:rmallon@gmail.com] 
Sent: Wednesday, August 20, 2014 4:34 AM
To: Sharma, Sanjeev; cpw@sgi.com; robinmholt@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-xp: Do not use BUG_ON(!spin_is_locked())

On 12/08/14 17:35, Sanjeev Sharma wrote:
> on some architecture spin_is_locked() always return false in 
> uniprocessor configuration and can therefore not be used with 
> BUG_ON.it would be advise to replace with lockdep_assert_held().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/misc/sgi-xp/xpc_channel.c | 6 +++---
>  drivers/misc/sgi-xp/xpc_sn2.c     | 2 +-
>  drivers/misc/sgi-xp/xpc_uv.c      | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_channel.c 
> b/drivers/misc/sgi-xp/xpc_channel.c
> index 128d561..240fe5a 100644
> --- a/drivers/misc/sgi-xp/xpc_channel.c
> +++ b/drivers/misc/sgi-xp/xpc_channel.c
> @@ -28,7 +28,7 @@ xpc_process_connect(struct xpc_channel *ch, unsigned 
> long *irq_flags)  {
>  	enum xp_retval ret;
>  
> -	DBUG_ON(!spin_is_locked(&ch->lock));
> +	lockdep_assert_held(!spin_is_locked(&ch->lock));

This is incorrect, and will break the build with CONFIG_LOCKDEP enabled.
You actually want:

	lockdep_assert_held(&ch->lock);

Same for the other instances.

~Ryan
