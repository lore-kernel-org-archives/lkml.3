Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3AWPAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:00:25 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55601 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766Ab3AWPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:00:24 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(z21eIzbb2dI98dI9371I936eI1be0I103dK1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz177df4h17326ah8275eha1495iz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h1155h)
X-WSS-ID: 0MH330G-02-6NF-02
X-M-MSG: 
Message-ID: <50FFFAF3.7030107@amd.com>
Date: Wed, 23 Jan 2013 09:00:03 -0600
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: Boris Ostrovsky <boris.ostrovsky@amd.com>, Jacob Shin <jacob.shin@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>  <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>  <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>  <20130120114828.GB16519@pd.tnic> <20130121160450 <50FE9E76.30702@xs4all.nl> <50FEA3F2.1070408@amd.com> <50FEAFEB.7020103@xs4all.nl> <50FEBA69.60106@amd.com> <50FEBE5D.7040905@xs4all.nl> <50FF20F2.9090503@amd.com> <50FFF15E.7010403@xs4all.nl>
In-Reply-To: <50FFF15E.7010403@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/2013 8:19 AM, Udo van den Heuvel wrote:
> On 2013-01-23 00:29, Suravee Suthikulanit wrote:
>> I sent out a patch
>> (http://marc.info/?l=linux-kernel&m=135889686523524&w=2) which should
>> implement
>> the workaround for AMD processor family15h model 10-1Fh erratum 746 in
>> the IOMMU driver.
>> In your case, the output from "setpci -s 00:00.02 F4.w" is "0050" which
>> tells me that BIOS doesn't
>> implement the work around. After patching, you should see the following
>> message in "dmesg".
>>
>> "AMD-Vi: Applying erratum 746 for IOMMU at 0000:00:00.2"
> Thanks!
> I'll check for that after these messages.
>
>> The following patch slightly modify
>> the code to always issue "COMPLETION_WAIT" after every command.  This
>> should help increasing the chance of reproducing
>> the issue.
> Should I test with these two patches together?
> Or should I apply the first one first and then see what the second can help?
Please try the first one first.  If the issue doesn't reproduce, you can 
use the second patch to try to trigger it.

Thank you,

Suravee
>
>
> Kind regards,
> Udo
>


