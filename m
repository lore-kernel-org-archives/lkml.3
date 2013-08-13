Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3HMLg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:36:28 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33323 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3HMLg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:36:26 -0400
Message-ID: <520A1A2E.9080500@linux.vnet.ibm.com>
Date: Tue, 13 Aug 2013 17:06:14 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com> <20130812123813.GD18018@pd.tnic> <20130812114932.52bb0314@samsung.com> <20130812150424.GH18018@pd.tnic> <20130812142557.2a43f155@samsung.com> <20130812175631.GI18018@pd.tnic>
In-Reply-To: <20130812175631.GI18018@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081311-5140-0000-0000-000003AB281E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 11:26 PM, Borislav Petkov wrote:
> On Mon, Aug 12, 2013 at 02:25:57PM -0300, Mauro Carvalho Chehab wrote:
>> Userspace still needs the EDAC sysfs, in order to identify how the
>> memory is organized, and do the proper memory labels association.
>>
>> What edac_ghes does is to fill those sysfs nodes, and to call the
>> existing tracing to report errors.

I suppose you're referring to the entries under /sys/devices/system/edac/mc?

I'm not sure I understand how this helps. ghes_edac seems to just be 
populating this based on dmi, which if I'm not mistaken, can be obtained 
in userspace (mcelog as an example).

Also, on my system, all DIMMs are being reported under mc0. I doubt if 
the labels there are accurate.

>
> This is the only reason which justifies EDAC's existence. Naveen, can
> your BIOS directly report the silkscreen label of the DIMM in error?
> Generally, can any BIOS do that?
>
> More specifically, what are those gdata_fru_id and gdata_fru_text
> things?

My understanding was that this provides the DIMM serial number, but I'm 
double checking just to be sure.

Thanks,
Naveen

>
> Because if it can, then having the memory error tracepoint come direct
> from APEI should be enough. The ghes_edac functionality could be then
> fallback for BIOSes which cannot report the silkscreen label and in such
> case I can imagine keeping both tracepoints, but disabling one of the
> two...
>

