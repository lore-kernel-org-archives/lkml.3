Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaLAJq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:46:29 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40261 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaLAJq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:46:27 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-9f-547c38f0d8ef
Message-id: <547C38EF.7030303@samsung.com>
Date: Mon, 01 Dec 2014 10:46:23 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] [media] V4L2: Deletion of an unnecessary check before
 the function call "vb2_put_vma"
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <547B98D5.8000909@users.sourceforge.net>
In-reply-to: <547B98D5.8000909@users.sourceforge.net>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xq7ofLGpCDG5Ok7Y437mc2WLZg9OM
	FltvSVucbXrDbnF51xw2i54NW1ktVj+rsJjy9ie7A4fH3i1ZHo9/vWTz2NJ/l92jb8sqRo+m
	U+2sHp83yQWwRXHZpKTmZJalFunbJXBl9B26zlSwlLNi2t7zrA2M59i7GDk5JARMJCaev8sI
	YYtJXLi3nq2LkYtDSGApo8Sn/r/MIAkhgU+MEosnVoHYvAJaEjMnbQCLswioSlx6ep0FxGYT
	MJToetvFBmKLCsRI3N+5mg2iXlDix+R7YDUiAlcZJV4sdQSxmQXyJd7M6GLtYuTgEBYokGg4
	6wKx9zubxLWZX5lAajgFTCX+rfrGBFFvJvHl5WFWCFteYvOat8wTGAVmIVkxC0nZLCRlCxiZ
	VzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEhPzXHYxLj1kdYhTgYFTi4dVcWx0ixJpYVlyZ
	e4hRgoNZSYR3ukFNiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGNNecdrMIr1/J8sxa8z0WBErt
	+WyQaBo3qcHxStkT7tRkkVerhWbLzPt45Prm7aeTLu9YKf1Ecd0VU++m1TFNyy833tjOK7w+
	6bWOVGPJ9NpXkyzkBf1FxC7OeVsi/snc7HHuNJXNGj8djiuLZTZObI2MrmwrXy8RzJB/QMen
	SPF8XUvGgn9KLMUZiYZazEXFiQC5O/lBVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-11-30 23:23, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 30 Nov 2014 23:10:51 +0100
>
> The vb2_put_vma() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-vmalloc.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index 3966b12..fba944e 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -154,8 +154,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
>   		}
>   		kfree(buf->pages);
>   	} else {
> -		if (buf->vma)
> -			vb2_put_vma(buf->vma);
> +		vb2_put_vma(buf->vma);
>   		iounmap(buf->vaddr);
>   	}
>   	kfree(buf);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

