Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaI3Hov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:44:51 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35259 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaI3Hot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:44:49 -0400
Message-ID: <542A60C3.1090503@gmail.com>
Date: Tue, 30 Sep 2014 15:50:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xen-scsiback: Need go to fail after xenbus_dev_error()
References: <5425967F.7020002@gmail.com> <5428E0ED.1050107@suse.com>	<54293742020000780003A48A@mail.emea.novell.com>	<54292707.90008@gmail.com> <542927C3.8010204@suse.com> <54292D6E.4060903@gmail.com> <54296559.5020301@citrix.com> <542A4E79.4020109@gmail.com> <542A54D6.8070906@suse.com>
In-Reply-To: <542A54D6.8070906@suse.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/14 14:59, Juergen Gross wrote:
> On 09/30/2014 08:32 AM, Chen Gang wrote:
>> On 9/29/14 21:57, David Vrabel wrote:
>>> On 29/09/14 10:59, Chen Gang wrote:
>>>>
>>>>
>>>> If no any additional reply within 2 days, I shall send patch v2 for it:
>>>>
>>>>    "use dev_warn() instead of xenbus_dev_error() and remove 'fail' code block"
>>>
>>> I think this driver is fine as-is and does not need any changes.
>>>
>>
>> OK, at least, at present, it is not a bug (will cause any issue).
>>
>> But for me, xenbus_dev_error() seems for printing generic errors,
>> dev_warn() is more suitable than it.
> 
> I'm unbiased regarding this one.
> 

After check all related code for xenbus_printf() and xenbus_dev_error(),
for me: if xenbus_printf() is for optional error, it will print warning;
all xenbus_dev_error() are not for optional error, except 2 area:

  drivers/pci/xen-pcifront.c:866:		xenbus_dev_error(pdev->xdev, err,
  drivers/pci/xen-pcifront.c:947:		xenbus_dev_error(pdev->xdev, err,

In fact, for me, not only they need be improved, but also skip 'err' for
pcifront_scan_root() and pcifront_rescan_root(), are they bugs? (I guess
they are). If they are really bugs, I shall send related patch for it.

>>
>> And 'fail' code block is useless now, need be removed, too (which will
>> let compiler report warning).
> 
> This should be part of the patch making the 'fail' block useless.
> 

Yeah, originally, it really should be, but if this patch can continue,
for me, can remove it in this patch, too (for the original patch, I
intended to remain it for discussing and analysing in this patch).

But all together, if you stick to remove 'fail' code block in original
patch, for me, it is OK.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
