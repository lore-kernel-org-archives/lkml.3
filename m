Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbbA2Be1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:34:27 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:59024 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbbA2BeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:34:24 -0500
Message-ID: <54C9673D.5090902@hurleysoftware.com>
Date: Wed, 28 Jan 2015 17:48:29 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>, Mark Rutland <mark.rutland@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Torez Smith <torez@redhat.com>
Subject: Re: inverse mapping from a struct console to device
References: <54C6984A.20501@redhat.com> <20150126205056.GA17169@leverpostej> <54C700BB.5030200@redhat.com> <20150127101440.GA17721@leverpostej> <54C77C6A.8000508@redhat.com> <20150127123002.GE17721@leverpostej> <54C7F821.1020609@redhat.com>
In-Reply-To: <54C7F821.1020609@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On 01/27/2015 03:42 PM, Jon Masters wrote:
> On 01/27/2015 07:30 AM, Mark Rutland wrote:
>> On Tue, Jan 27, 2015 at 11:54:18AM +0000, Jon Masters wrote:
> 
>>> Here's an example of the data we get in the SPCR for reference:
>>>
>>> [0012]               Serial Port Register : [Generic Address Structure]
>>> [0001]                           Space ID : 00 [SystemMemory]
>>> [0001]                          Bit Width : 08
>>> [0001]                         Bit Offset : 00
>>> [0001]               Encoded Access Width : 01 [Byte Access:8]
>>> [0008]                            Address : 000000001c020000
>>>
>>> [0001]                     Interrupt Type : 08
>>> [0001]                PCAT-compatible IRQ : 00
>>> [0004]                          Interrupt : 0000006C
>>> [0001]                          Baud Rate : 07
>>> [0001]                             Parity : 00
>>> [0001]                          Stop Bits : 01
>>> [0001]                       Flow Control : 00
>>> [0001]                      Terminal Type : 00
>>> [0001]                           Reserved : 00
>>>
>>> The actual structure is longer, but you get the idea. I first map this
>>> to the correct Device in the DSDT with a device_initcall that will find
>>> the table then walk the ACPI namespace to find the corresponding device.
>>> This is stashed so that later we can perform the same kind of comparison
>>> that you do with DT today. I also populate options, though so far have
>>> only bothered to implement baud rate.
>>
>> I would recommend that you set up as many of these ASAP. Otherwise
>> someone's certain to mess up a table and we can never add them later.
> 
> So this is why I'm doing this (and other annoying things) right now - to
> make sure that vendors shipping platforms have valid data we can also
> use. If we wait until later, we'll have systems that potentially do the
> wrong thing. The table above is an example of one for the Mustang. I had
> the revision bumped to 2 and the IRQ information added to the reference
> one, and I've also verified the tables for Seattle, as well as "other"
> hardware that is in the pipeline from other vendors.
> 
>> Otherwise, sounds good!
> 
> So I'm handing this to Torez Smith to followup on (please keep her
> copied on replies to this thread). I'm attaching a *hack* patch I put
> together to proof of concept and then Torez will make this into
> something actually useable/upstreamable (without hard coded static baud
> strings and the like that I used to hack it up).

The Serial Port Console Redirection (SPCR) Table is patented by
Microsoft (spec and patent notice downloadable here
https://msdn.microsoft.com/en-us/library/windows/hardware/dn639132(v=vs.85).aspx )
and covered under the Microsoft Community Promise here
http://www.microsoft.com/openspecifications/en/us/programs/community-promise/default.aspx

The Micosoft Community Promise does not look compatible with GPL 2;
or more specifically, whomever eventually submitted the patch would likely not
be able to meet the criteria set forth by the Developer's Certificate of Origin 1.1
in Documentation/SubmittingPatches

Regards,
Peter Hurley
