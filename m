Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3CRWy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:54:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40423 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3CRWyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:54:55 -0400
Message-ID: <51479AAD.7040209@zytor.com>
Date: Mon, 18 Mar 2013 15:52:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, kdump: Set crashkernel_low automatically
References: <514783B4.2030401@zytor.com> <1363641957-5247-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1363641957-5247-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 02:25 PM, Yinghai Lu wrote:
> Current code does not set low range for crashkernel if the user
> does not specify that.
> 
> That cause regressions on system that does not support intel_iommu
> properly.
> 
> Chao said that his system does work well on 3.8 without extra parameter.
> even iommu does not work with kdump.
> 
> Set crashkernel_low automatically if the user does not specify that.
> 
> For system that does support IOMMU with kdump properly, user could
> specify crashkernel_low=0 to save that 72M low ram.
> 
> -v3: add swiotlb_size() according to Konrad.
> 
> Reported-by: WANG Chao <chaowang@redhat.com>
> Tested-by: WANG Chao <chaowang@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Can we get a bit more of an explanation instead of "and etc 8M"?  At
least a hint of what kind of objects would go in there...

	-hpa


