Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab3HMRSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:18:01 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48642 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3HMRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:17:59 -0400
Message-ID: <520A6A30.1030406@linux.vnet.ibm.com>
Date: Tue, 13 Aug 2013 22:47:36 +0530
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
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com> <20130812114404.3bd64fa0@samsung.com> <520A1B5E.8040105@linux.vnet.ibm.com> <20130813094147.062317f8@concha.lan>
In-Reply-To: <20130813094147.062317f8@concha.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081317-5140-0000-0000-000003AB73AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 06:11 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 13 Aug 2013 17:11:18 +0530
> "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:
>
>> On 08/12/2013 08:14 PM, Mauro Carvalho Chehab wrote:
>>>> But, this only seems to expose the APEI data as a string
>>>> and doesn't look to really make all the fields available to user-space
>>>> in a raw manner. Not sure how well this can be utilised by a user-space
>>>> tool. Do you have suggestions on how we can do this?
>>>
>>> There's already an userspace tool that handes it:
>>> 	https://git.fedorahosted.org/cgit/rasdaemon.git/
>>>
>>> What is missing there on the current version is the bits that would allow
>>> to translate from APEI way to report an error (memory node, card, module,
>>> bank, device) into a DIMM label[1].
>>
>> If I'm reading this right, all APEI data seems to be squashed into a
>> string in mc_event.
>
> Yes. We had lots of discussion about how to map memory errors over the
> last couple years. Basically, it was decided that the information that
> could be decoded into a DIMM to be mapped as integers, and all other
> driver-specific data to be added as strings.
>
> On the tests I did, different machines/vendors fill the APEI data on
> a different way, with makes harder to associate them to a DIMM.

Ok, so it looks like ghes_edac isn't quite useful yet.

In the meantime, like Boris suggests, I think we can have a different 
trace event for raw APEI reports - userspace can use it as it pleases.

Once ghes_edac gets better, users can decide whether they want raw APEI 
reports or the EDAC-processed version and choose one or the other trace 
event.

Regards,
Naveen

