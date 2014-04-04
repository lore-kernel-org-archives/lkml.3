Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaDDJTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:19:10 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38961 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaDDJS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:18:58 -0400
Message-ID: <533E78FA.60204@gmail.com>
Date: Fri, 04 Apr 2014 17:18:50 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: tytso@mit.edu, adilger.kernel@dilger.ca
CC: linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gxt@mprc.pku.edu.cn
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
References: <53396AC1.10108@gmail.com>
In-Reply-To: <53396AC1.10108@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintains:

Please help check this patch, when you have time, thanks.


On 03/31/2014 09:16 PM, Chen Gang wrote:
> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Need
> append 'ULL' for it.
> 
> The related warning (with allmodconfig under unicore32):
> 
>     CC [M]  fs/ext4/extents_status.o
>   fs/ext4/extents_status.c: In function ‘__es_remove_extent’:
>   fs/ext4/extents_status.c:813: warning: integer constant is too large for ‘long’ type
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  fs/ext4/extents_status.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 0a014a7..0ebc212 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -810,7 +810,7 @@ retry:
>  
>  			newes.es_lblk = end + 1;
>  			newes.es_len = len2;
> -			block = 0x7FDEADBEEF;
> +			block = 0x7FDEADBEEFULL;
>  			if (ext4_es_is_written(&orig_es) ||
>  			    ext4_es_is_unwritten(&orig_es))
>  				block = ext4_es_pblock(&orig_es) +
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
