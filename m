Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaKRJNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:13:39 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45548 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaKRJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:13:36 -0500
Message-ID: <546B0DBB.7080000@gmail.com>
Date: Tue, 18 Nov 2014 11:13:31 +0200
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Benny Halevy <bhalevy@primarydata.com>,
        Boaz Harrosh <bharrosh@panasas.com>, osd-dev@open-osd.org
CC: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [osd-dev] [PATCH 1/1] exofs: Deletion of an unnecessary check
 before the function call "ore_put_io_state"
References: <5307CAA2.8060406@users.sourceforge.net>	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>	<530A086E.8010901@users.sourceforge.net>	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>	<530A72AA.3000601@users.sourceforge.net>	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	<530B5FB6.6010207@users.sourceforge.net>	<alpine.DEB.2.10.1402241710370.2074@hadrien>	<530C5E18.1020800@users.sourceforge.net>	<alpine.DEB.2.10.1402251014170.2080@hadrien>	<530CD2C4.4050903@users.sourceforge.net>	<alpine.DEB.2.10.1402251840450.7035@hadrien>	<530CF8FF.8080600@users.sourceforge.net>	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	<530DD06F.4090703@users.sourceforge.net>	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	<5317A59D.4@users.sourceforge.net> <546B0D08.2070305@users.sourceforge.net>
In-Reply-To: <546B0D08.2070305@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 11:10 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 18 Nov 2014 10:05:19 +0100
> 
> The ore_put_io_state() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/exofs/ore_raid.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
> index 84529b8..5dc7c4c 100644
> --- a/fs/exofs/ore_raid.c
> +++ b/fs/exofs/ore_raid.c
> @@ -716,6 +716,5 @@ void _ore_free_raid_stuff(struct ore_io_state *ios)
>  		if (ios->extra_part_alloc)
>  			kfree(ios->per_dev[0].sglist);
>  	}
> -	if (ios->ios_read_4_write)
> -		ore_put_io_state(ios->ios_read_4_write);
> +	ore_put_io_state(ios->ios_read_4_write);
>  }
> 

Thanks will submit for next Kernel
Boaz
