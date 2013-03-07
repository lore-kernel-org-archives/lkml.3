Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab3CGThW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:37:22 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:42702 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3CGThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:37:20 -0500
Message-ID: <5138EC6C.6030906@suse.cz>
Date: Thu, 07 Mar 2013 20:37:16 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: kswapd craziness round 2
References: <5121C7AF.2090803@numascale-asia.com> <CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com> <51254AD2.7000906@suse.cz> <CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com> <512F8D8B.3070307@suse.cz> <CAJd=RBD=eT=xdEy+v3GBZ47gd47eB+fpF-3VtfpLAU7aEkZGgA@mail.gmail.com>
In-Reply-To: <CAJd=RBD=eT=xdEy+v3GBZ47gd47eB+fpF-3VtfpLAU7aEkZGgA@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 03:02 PM, Hillf Danton wrote:
> On Fri, Mar 1, 2013 at 1:02 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>
>> Ok, no difference, kswap is still crazy. I'm attaching the output of
>> "grep -vw '0' /proc/vmstat" if you see something there.
>>
> Thanks to you for test and data.
> 
> Lets try to restore the deleted nap, then.

Oh, it seems to be nice now:
root       579  0.0  0.0      0     0 ?        S    Mar04   0:13 [kswapd0]

Thanks.

> Hillf
> --- a/mm/vmscan.c	Thu Feb 21 20:01:02 2013
> +++ b/mm/vmscan.c	Fri Mar  1 21:55:40 2013
> @@ -2817,6 +2817,10 @@ loop_again:
>  		 */
>  		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
>  			break;
> +
> +		if (sc.priority < DEF_PRIORITY - 2)
> +			congestion_wait(BLK_RW_ASYNC, HZ/10);
> +
>  	} while (--sc.priority >= 0);
> 
>  out:
> --
> 


-- 
js
suse labs
