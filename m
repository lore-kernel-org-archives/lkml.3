Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3HLMmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:42:02 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39948 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3HLMl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:41:57 -0400
Message-ID: <5208D80D.5030206@linux.vnet.ibm.com>
Date: Mon, 12 Aug 2013 18:11:49 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com>
In-Reply-To: <20130812083355.47c1bae8@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081212-2000-0000-0000-00000D484659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 05:03 PM, Mauro Carvalho Chehab wrote:
> Em Sat, 10 Aug 2013 20:03:22 +0200
> Borislav Petkov <bp@alien8.de> escreveu:
>
>> On Thu, Aug 08, 2013 at 04:38:22PM -0300, Mauro Carvalho Chehab wrote:
>>> Em Thu, 08 Aug 2013 23:57:51 +0530
>>> "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:
>>>
>>>> Enable memory error trace event in cper.c
>>>
>>> Why do we need to do that? Memory error events are already handled
>>> via edac_ghes module,
>>
>> If APEI gives me all the required information in order to deal with the
>> hardware error - and it looks like it does - then the additional layer
>> of ghes_edac is not needed.
>
> APEI is just the mechanism that collects the data, not the mechanism
> that reports to userspace.

I think what Boris is saying is that ghes_edac isn't adding anything 
more here given what we get from APEI structures. So, there doesn't seem 
to be a need to add dependency on edac for this purpose.

Further, ghes_edac seems to require EDAC_MM_EDAC to be compiled into the 
kernel (not a module). So, more dependencies.

>
> The current implementation is that APEI already reports those errors
> via ghes_edac driver. It also reports the very same error via MCE
> (although the APEI interface to MCE is currently broken for everything
> that it is not Nehalem-EX - as it basically emulates the MCE log for
> that specific architecture).

So, I looked at ghes_edac and it basically seems to boil down to 
trace_mc_event. But, this only seems to expose the APEI data as a string 
and doesn't look to really make all the fields available to user-space 
in a raw manner. Not sure how well this can be utilised by a user-space 
tool. Do you have suggestions on how we can do this?

Thanks,
Naveen

