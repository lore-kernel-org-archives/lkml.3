Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3IYRGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:06:13 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48863 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3IYRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:06:11 -0400
MIME-Version: 1.0
In-Reply-To: <5242E6FF.50800@intel.com>
References: <1378783035-15681-1-git-send-email-tianyu.lan@intel.com>
 <1378783035-15681-2-git-send-email-tianyu.lan@intel.com> <20130925001902.GF9302@google.com>
 <5242E6FF.50800@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Sep 2013 11:05:50 -0600
Message-ID: <CAErSpo7-KO1C=FKzg1_i-h4Tm4ZNiiL5syPWTc3eJjAgGiUnZg@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI/ACPI: Convert ACPI PCI Hot Plug core debug
 fuction to dynamic debug function
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 7:37 AM, Lan Tianyu <tianyu.lan@intel.com> wrote:
> On 09/25/2013 08:19 AM, Bjorn Helgaas wrote:
>>
>> On Mon, Sep 09, 2013 at 11:17:15PM -0400, tianyu.lan@intel.com wrote:
>>>
>>> From: Lan Tianyu <tianyu.lan@intel.com>
>>>
>>> This patch is to use pr_debug/info/warn/err to replace acpiphp debug
>>> functions and remove module's debug param.
>>> ...
>>
>>
>>>   /* local variables */
>>> @@ -61,9 +60,7 @@ static struct acpiphp_attention_info *attention_info;
>>>   MODULE_AUTHOR(DRIVER_AUTHOR);
>>>   MODULE_DESCRIPTION(DRIVER_DESC);
>>>   MODULE_LICENSE("GPL");
>>> -MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
>>>   MODULE_PARM_DESC(disable, "disable acpiphp driver");
>>> -module_param_named(debug, acpiphp_debug, bool, 0644);
>>
>>
>> I have notes about booting with the "acpiphp.debug" parameter to turn
>> on debugging.  Can you tell me the way to do the equivalent with
>> dynamic debug?  I'll add that to the changelog before merging this.
>
> Hi Bjorn:
>         Sure, the counterparts of dynamic debug are "acpiphp.dyndbg=+p" and
> "acpiphp_ibm.dyndbg=+p" parameters. Thanks to add them.

And turn on CONFIG_DYNAMIC_DEBUG.  I updated the changelogs and
applied both patches to my pci/misc branch for v3.13.  Thanks!

Bjorn
