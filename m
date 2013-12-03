Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3LCP22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:28:28 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42852 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3LCP21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:28:27 -0500
Message-ID: <529DF897.1080303@linaro.org>
Date: Tue, 03 Dec 2013 15:28:23 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/block: Correctly define structures in
 public headers on ARM32 and ARM64
References: <1386083382-7306-1-git-send-email-julien.grall@linaro.org> <529E039A02000078001097F5@nat28.tlf.novell.com>
In-Reply-To: <529E039A02000078001097F5@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 03:15 PM, Jan Beulich wrote:
>>>> On 03.12.13 at 16:09, Julien Grall <julien.grall@linaro.org> wrote:
>> --- a/include/xen/interface/io/blkif.h
>> +++ b/include/xen/interface/io/blkif.h
>> @@ -146,7 +146,7 @@ struct blkif_request_segment_aligned {
>>  struct blkif_request_rw {
>>  	uint8_t        nr_segments;  /* number of segments                   */
>>  	blkif_vdev_t   handle;       /* only for read/write requests         */
>> -#ifdef CONFIG_X86_64
>> +#if defined(CONFIG_X86_64) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> 
> Perhaps using
> 
> #ifndef CONFIG_X86_32
> 
> would be the better one, assuming that we won't add further
> non-64-bit-clean ABI variants?

I'm fine with this solution. I will resend the patch.

-- 
Julien Grall
