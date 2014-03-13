Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaCMN31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:29:27 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36528 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCMN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:29:25 -0400
Message-ID: <5321B2B2.9060109@acm.org>
Date: Thu, 13 Mar 2014 08:29:22 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Matthew Garrett <matthew.garrett@nebula.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com> <1511662.Ly2fOjCGKz@vostro.rjw.lan> <1392765307.3488.1.camel@x230.lan> <20140312230007.GA1817@amd.pavel.ucw.cz> <1394666568.25122.1.camel@x230> <20140313072204.GA7181@amd.pavel.ucw.cz> <1394695475.25122.4.camel@x230> <20140313083832.GA8902@amd.pavel.ucw.cz>
In-Reply-To: <20140313083832.GA8902@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:38 AM, Pavel Machek wrote:
> On Thu 2014-03-13 07:24:36, Matthew Garrett wrote:
>> On Thu, 2014-03-13 at 08:22 +0100, Pavel Machek wrote:
>>> On Wed 2014-03-12 23:22:49, Matthew Garrett wrote:
>>>> No. The power meter driver knows nothing about IPMI. It makes no IPMI
>>>> calls. There's no requirement that a vendor implement it via IPMI.
>>> Yet you claim that IMPI is needed for that, and that's why you made
>>> IMPI default.
>> I claim that the ACPI spec defines the behaviour of IPMI operation
>> regions, and so we should default IPMI to Y in order to (by default)
>> implement the ACPI spec.
>>
>>> So ... do we need dmi-based blacklist?
>> I don't see why.
> Your reasoning for default y was that "power meter depends on
> this". Then, claim that "power meter does not officially depend on it"
> so it would be wrong to have a dependency.

I believe the correct statement is "On some systems power meter depends
on it".

>
> Defaults are not right solution; system should still work if I select
> non-default settings. Which you claim is not a case, but you don't see
> why you should fix it.

If something is implemented using IPMI, then IPMI has to be there to
use it.  Matthew's statement was:

For example, if you load the ACPI power meter driver before you've
installed the ACPI IPMI driver you'll typically get failures (most
vendors implement it via IPMI).

Other things besides the power meter can be implemented using IPMI, it's
up to the vendor.  How will those things work if IPMI is not available?

-corey

