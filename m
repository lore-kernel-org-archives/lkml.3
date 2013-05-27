Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3E0KCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:02:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50005 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3E0KCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:02:49 -0400
Message-ID: <51A32F1F.5020109@linux.vnet.ibm.com>
Date: Mon, 27 May 2013 15:32:07 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, mikey@neuling.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc, perf: Ignore separate BHRB privilege state
 filter request
References: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com> <1369201667-9048-2-git-send-email-khandual@linux.vnet.ibm.com> <1369206855.12874.9.camel@concordia> <519C88D9.30009@linux.vnet.ibm.com>
In-Reply-To: <519C88D9.30009@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052709-1618-0000-0000-000003F695E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 02:29 PM, Anshuman Khandual wrote:
>>
>> Your description from patch 0 should be here.
> Does it sound better ?
> 
>>
>>> -	if ((br_privilege != 7) && (br_privilege != 0))
>>> -		return -1;
>>> +
>>> +	if (br_privilege)
>>> +		pr_info("BHRB privilege state filter request %llx ignored\n",
>>> +								br_privilege);
>>
>> Don't do that. Ignoring the br_privilege is either the right thing to do
>> in which case we do it and print nothing,
> 
> 
> I thought the informational print would at least make the user aware
> of the fact that the separate filter request for BHRB went ignored.
> Can we add this some where in the documentation ?

So, what we decide here ? We will just ignore any separate BHRB
privilege state filter request without printing any informational
event or warning ?


