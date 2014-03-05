Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaCEXIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:08:53 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:55781
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbaCEXIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:08:51 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N1ZKAH-07-7UI-02
X-M-MSG: 
Message-ID: <5317AE79.6090606@amd.com>
Date: Wed, 5 Mar 2014 17:08:41 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kim.naru@amd.com>, <jay.cornwall@amd.com>
Subject: Re: [PATCH] iommu/amd: Fix logics to determine and checking max PASID
References: <1394046068-3858-1-git-send-email-suravee.suthikulpanit@amd.com> <20140305223544.GA2813@8bytes.org>
In-Reply-To: <20140305223544.GA2813@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/2014 4:35 PM, Joerg Roedel wrote:
>> -		cmd->data[1]  = pasid & PASID_MASK;
>> >+		cmd->data[1]  = pasid & amd_iommu_max_pasid;
> ... masking out the other bits is redundant.
>
>
> 	Joerg

Agree.  I can take out the masking stuff here, but I think we should be 
using the amd_iommu_max_pasid instead of hard coded PASID_MASK for the rest.

Suravee


