Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaKQAPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:15:43 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:54398 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaKQAPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:15:42 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "riel@redhat.com" <riel@redhat.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "davidlohr@hp.com" <davidlohr@hp.com>
Subject: Re: [PATCH 1/3] hugetlb: fix hugepages= entry in
 kernel-parameters.txt
Thread-Topic: [PATCH 1/3] hugetlb: fix hugepages= entry in
 kernel-parameters.txt
Thread-Index: AQHQAfsCk6Srn4RM3k6u+8kNLRr+cA==
Date: Mon, 17 Nov 2014 00:11:17 +0000
Message-ID: <20141117001154.GA4667@hori1.linux.bs1.fc.nec.co.jp>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
 <1415831593-9020-2-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1415831593-9020-2-git-send-email-lcapitulino@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.20]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <F0F1F8460A9A9F48AE17EA8680997B13@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:33:11PM -0500, Luiz Capitulino wrote:
> The hugepages= entry in kernel-parameters.txt states that
> 1GB pages can only be allocated at boot time and not
> freed afterwards. This is not true since commit
> 944d9fec8d7aee, at least for x86_64.
> 
> Instead of adding arch-specifc observations to the
> hugepages= entry, this commit just drops the out of date
> information. Further information about arch-specific
> support and available features can be obtained in the
> hugetlb documentation.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  Documentation/kernel-parameters.txt | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 479f332..d919af0 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1228,9 +1228,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			multiple times interleaved with hugepages= to reserve
>  			huge pages of different sizes. Valid pages sizes on
>  			x86-64 are 2M (when the CPU supports "pse") and 1G
> -			(when the CPU supports the "pdpe1gb" cpuinfo flag)
> -			Note that 1GB pages can only be allocated at boot time
> -			using hugepages= and not freed afterwards.
> +			(when the CPU supports the "pdpe1gb" cpuinfo flag).
>  
>  	hvc_iucv=	[S390] Number of z/VM IUCV hypervisor console (HVC)
>  			       terminal devices. Valid values: 0..8
> -- 
> 1.9.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>