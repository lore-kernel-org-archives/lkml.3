Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab3DBPlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:41:37 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:5086 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932491Ab3DBPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:41:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z551bizbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MKMWX2-02-NCF-02
X-M-MSG: 
Message-ID: <515AFC25.5060501@amd.com>
Date: Tue, 2 Apr 2013 10:41:25 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com> <20130402143335.GB15687@8bytes.org> <20130402144037.GE5488@pd.tnic> <20130402150302.GF15687@8bytes.org> <20130402152956.GE4391@pd.tnic>
In-Reply-To: <20130402152956.GE4391@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 10:29 AM, Borislav Petkov wrote:
> On Tue, Apr 02, 2013 at 05:03:04PM +0200, Joerg Roedel wrote:
>> On Tue, Apr 02, 2013 at 04:40:37PM +0200, Borislav Petkov wrote:
>>> While you guys are at it, can someone fix this too pls (ASUS board with
>>> a PD on it).
>>>
>>> [    0.220342] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
>>> [    0.220398] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
>>> [    0.220451] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
>>> [    0.220506] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)
>> That is actually a BIOS problem. I wonder whether it would help to turn this
>> into a WARN_ON to get the board vendors to release working BIOSes.
>> Opinions?
> Good luck trying to get ASUS to fix anything in their BIOS :(.
I have tried to contact Asus in the past to have them fix the issue, but 
I got no luck.  Once it is out in the field, it's very difficult to get 
them to make changes.  I am also addressing this issue with the BIOS 
team for the future hardware.

Turning this into WARN_ON() at this point might break a lot of systems 
currently out in the field.  However, users can always switching to use 
"intremap=off" but this might not be obvious.

Suravee

> Can't we detect the SB IOAPIC some other way in this case?
>


