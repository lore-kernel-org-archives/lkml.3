Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbaICKI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbaICKIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:08:25 -0400
Message-ID: <5406E889.7080904@redhat.com>
Date: Wed, 03 Sep 2014 18:08:09 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com
CC: stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: hv: util: Properly pack the data for file
 copy functionality
References: <1409710907-20818-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1409710907-20818-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 10:21 AM, K. Y. Srinivasan wrote:
> Properly pack the data for file copy functionality. Patch based on
> investigation done by Matej Muzila <mmuzila@redhat.com>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: qge@redhat.com
> Cc: <stable@vger.kernel.org>
> ---
>  include/uapi/linux/hyperv.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
> index 78e4a86..0a8e6ba 100644
> --- a/include/uapi/linux/hyperv.h
> +++ b/include/uapi/linux/hyperv.h
> @@ -137,7 +137,7 @@ struct hv_do_fcopy {
>  	__u64	offset;
>  	__u32	size;
>  	__u8	data[DATA_FRAGMENT];
> -};
> +} __attribute__((packed));
>  
>  /*
>   * An implementation of HyperV key value pair (KVP) functionality for Linux.

Acked-by: Jason Wang <jasowang@redhat.com>
