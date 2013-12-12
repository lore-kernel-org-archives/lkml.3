Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3LLPMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:12:05 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28793 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LLPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:12:03 -0500
X-IronPort-AV: E=Sophos;i="4.93,878,1378857600"; 
   d="scan'208";a="81368906"
Message-ID: <52A9D23F.3010005@citrix.com>
Date: Thu, 12 Dec 2013 16:11:59 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>,
        Julien Grall <julien.grall@linaro.org>
CC: <xen-devel@lists.xenproject.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <linux-kernel@vger.kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        <patches@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v2] xen/block: Correctly define structures
 in public headers on ARM32 and ARM64
References: <1386085237-8334-1-git-send-email-julien.grall@linaro.org> <1386857960.11201.57.camel@kazak.uk.xensource.com>
In-Reply-To: <1386857960.11201.57.camel@kazak.uk.xensource.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13 15:19, Ian Campbell wrote:
> On Tue, 2013-12-03 at 15:40 +0000, Julien Grall wrote:
>> On ARM (32 bits and 64 bits), the double-word is 8-bytes aligned. This will
>> result on different structure from Xen and Linux repositories.
>>
>> As Linux is using __packed__ attribute, it must have a 4-bytes padding before
>> each "id" field.
>>
>> This change breaks guest block support with older kernel. IMHO, it's acceptable
>> because Xen on ARM is still on Tech Preview and the hypercall ABI is not yet
>> freezed.
>>
>> Only one architecture (x86_32) doesn't have 64-bit ABI for the block interface.
>> Don't add padding if Linux is compiled for this architecture.
> 
> Konrad asked for confirmation that this didn't change x86.

I've also tested this using various combinations of kernels, and it
seems to be perfectly fine, so:

Acked-by: Roger Pau Monné <roger.pau@citrix.com>

