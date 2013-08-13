Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3HMLVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:21:46 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57026 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab3HMLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:21:44 -0400
Message-ID: <520A16BD.30201@linux.vnet.ibm.com>
Date: Tue, 13 Aug 2013 16:51:33 +0530
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
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com> <20130812125343.GE18018@pd.tnic>
In-Reply-To: <20130812125343.GE18018@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081311-3864-0000-0000-000009920339
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 06:23 PM, Borislav Petkov wrote:
> On Mon, Aug 12, 2013 at 06:11:49PM +0530, Naveen N. Rao wrote:
>> So, I looked at ghes_edac and it basically seems to boil down to
>> trace_mc_event. But, this only seems to expose the APEI data as a
>> string and doesn't look to really make all the fields available to
>> user-space in a raw manner. Not sure how well this can be utilised
>> by a user-space tool.
>
> Well, your tracepoint dumps the decoded memory error too. So all the
> information we need is already there, without edac. Or am I missing some
> bits?
>
> Thus why I'm saying is that we don't need the additional edac layer.
>

You're right - my trace point makes all the data provided by apei as-is 
to userspace. However, ghes_edac seems to squash some of this data into 
a string when reporting through mc_event.

Regards,
Naveen

