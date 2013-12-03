Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3LCQUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:20:01 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:63283 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3LCQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:19:59 -0500
Message-ID: <529E04AB.5060304@linaro.org>
Date: Tue, 03 Dec 2013 16:19:55 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: xen-devel@lists.xenproject.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v2] xen/block: Correctly define structures in public headers
 on ARM32 and ARM64
References: <1386085237-8334-1-git-send-email-julien.grall@linaro.org> <20131203160018.67542a53@alan.etchedpixels.co.uk>
In-Reply-To: <20131203160018.67542a53@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 04:00 PM, One Thousand Gnomes wrote:
> On Tue,  3 Dec 2013 15:40:37 +0000
> Julien Grall <julien.grall@linaro.org> wrote:
> 
>> On ARM (32 bits and 64 bits), the double-word is 8-bytes aligned. This will
>> result on different structure from Xen and Linux repositories.
>>
>> As Linux is using __packed__ attribute, it must have a 4-bytes padding before
>> each "id" field.
>>
>> This change breaks guest block support with older kernel. IMHO, it's acceptable
>> because Xen on ARM is still on Tech Preview and the hypercall ABI is not yet
>> freezed.
> 
> How does a guest ascertain which API to use ?
> 
> How does the patch ensure new kernels on existing hypervisor versions
> don't break ?

As Ian said on the thread "xen-block: correctly define structures in
public headers" (see thread https://lkml.org/lkml/2013/12/3/155), the
ABI is not yet fixed for ARM.

> 
> What is the failure case given the alignment change seems potentially to
> produce valid but incorrect I/O requests - can it cause corruption ?

The request ID will likely be wrong, so the guest won't accept the
request. It should not corrupt the block device.

> It seems to me you should be defining
> 
> struct blkif_request_rw_v2
> 
> and using the correct version according to which API the hypervisor
> requires, not just breaking it.

This API doesn't involve the hypervisor. It's only a way to talk between
DOM0 and a guest. Without this change you will break compatibility with
other OSes.

-- 
Julien Grall
