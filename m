Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3HMQ4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:56:23 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49088 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3HMQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:56:19 -0400
Message-ID: <520A651E.3050604@linux.vnet.ibm.com>
Date: Tue, 13 Aug 2013 22:25:58 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com> <20130812123813.GD18018@pd.tnic> <20130812114932.52bb0314@samsung.com> <20130812150424.GH18018@pd.tnic> <20130812142557.2a43f155@samsung.com> <20130812175631.GI18018@pd.tnic> <520A1A2E.9080500@linux.vnet.ibm.com> <20130813092154.1e17385f@concha.lan>
In-Reply-To: <20130813092154.1e17385f@concha.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081316-1396-0000-0000-00000366719C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 05:51 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 13 Aug 2013 17:06:14 +0530
> "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:
>
>> On 08/12/2013 11:26 PM, Borislav Petkov wrote:
>>> On Mon, Aug 12, 2013 at 02:25:57PM -0300, Mauro Carvalho Chehab wrote:
>>>> Userspace still needs the EDAC sysfs, in order to identify how the
>>>> memory is organized, and do the proper memory labels association.
>>>>
>>>> What edac_ghes does is to fill those sysfs nodes, and to call the
>>>> existing tracing to report errors.
>>
>> I suppose you're referring to the entries under /sys/devices/system/edac/mc?
>
> Yes.
>
>>
>> I'm not sure I understand how this helps. ghes_edac seems to just be
>> populating this based on dmi, which if I'm not mistaken, can be obtained
>> in userspace (mcelog as an example).
>>
>> Also, on my system, all DIMMs are being reported under mc0. I doubt if
>> the labels there are accurate.
>
> Yes, this is the current status of ghes_edac, where BIOS doesn't provide any
> reliable way to associate a given APEI report to a physical DIMM slot label.
>
> The plan is to add more logic there as BIOSes start to provide some reliable
> way to do such association. I discussed this subject with a few vendors
> while I was working at Red Hat.

Hmm... is there anything specific in the APEI report that could help? 
More importantly, is there a need to do this in-kernel rather than in 
user-space?

Thanks,
Naveen

