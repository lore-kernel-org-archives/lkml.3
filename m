Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaDGRLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:11:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:34785 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbaDGRLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:11:50 -0400
X-IronPort-AV: E=Sophos;i="4.97,811,1389744000"; 
   d="scan'208";a="118761079"
Message-ID: <5342DC54.2070608@citrix.com>
Date: Mon, 7 Apr 2014 18:11:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen-blkback: only attach blkback if the required features
 are met
References: <1396622471-13114-1-git-send-email-roger.pau@citrix.com> <533EC966.7030101@citrix.com> <533ECC32.5070302@citrix.com>
In-Reply-To: <533ECC32.5070302@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 16:13, Roger Pau Monné wrote:
> On 04/04/14 17:01, David Vrabel wrote:
>> On 04/04/14 15:41, Roger Pau Monne wrote:
>>> Blkback cannot work properly on auto-translated guests if Xen doesn't
>>> update the IOMMU when performing grant maps/unmaps, so only attach if
>>> the newly introduced XENFEAT_hvm_gntmap_supports_iommu is found.
>>
>> Can you explain the problem in more detail and which guest
>> configurations are affected?
>>
>> This isn't a problem that is specific to blkback, but any backend that
>> grant maps and passes the foreign pages to a device so there needs to be
>> a generic solution.
>>
>> Why can't this be fixed by having the swiotlb bounce foreign pages?
> 
> Yes, it could be fixed with that, FreeBSD has been doing it for a long time.
> 
> But since nobody has complained about this, and the issue has been there
> for a long time, I'm not sure it's worth adding all the bounce buffer
> code for what seems to be an unused configuration.

Ok.  Now that netback also grant maps.  Can you make this a generic
function and call from netback and blkback?

David
