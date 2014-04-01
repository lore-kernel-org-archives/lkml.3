Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaDAHI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:08:58 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:53892 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDAHI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:08:57 -0400
Date: Tue, 1 Apr 2014 09:08:56 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH v2] avr32: replace simple_strtoul() with kstrtoul()
Message-ID: <20140401070856.GA22185@samfundet.no>
References: <1395177941-5680-1-git-send-email-artagnon@gmail.com>
 <1396312962-12483-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396312962-12483-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 31 Mar 2014 20:42:42 -0400 or thereabout, Ramkumar Ramachandra wrote:
> simple_strtoul() is marked for obsoletion; use the newer and more
> pleasant kstrtoul() in its place.
> 
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  arch/avr32/kernel/cpu.c | 48 ++++++++++++++++++++++++++----------------------
>  1 file changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/avr32/kernel/cpu.c b/arch/avr32/kernel/cpu.c

<snipp diff>

> @@ -61,11 +63,11 @@ static ssize_t store_pc0count(struct device *dev,
>  				const char *buf, size_t count)
>  {
>  	unsigned long val;
> -	char *endp;
> +	int ret;
>  
> -	val = simple_strtoul(buf, &endp, 0);
> -	if (endp == buf)
> -		return -EINVAL;
> +	ret = kstroul(buf, 0, &val);

I fixed this typo to kstrtoul.

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
