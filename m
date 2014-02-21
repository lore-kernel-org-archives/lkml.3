Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaBUNUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:20:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:24096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbaBUNUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:20:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,519,1389772800"; 
   d="scan'208";a="479129626"
Message-ID: <530754BE.5090301@linux.intel.com>
Date: Fri, 21 Feb 2014 15:29:34 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, sarah.a.sharp@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jianqian <jianqiang.tang@intel.com>
Subject: Re: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
References: <20140108014550.GA7823@kroah.com> <Pine.LNX.4.44L0.1401081046300.1659-100000@iolanthe.rowland.org> <20140108195334.GB27907@psi-dev26.jf.intel.com>
In-Reply-To: <20140108195334.GB27907@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 09:53 PM, David Cohen wrote:
> On Wed, Jan 08, 2014 at 10:48:06AM -0500, Alan Stern wrote:
>> On Tue, 7 Jan 2014, Greg KH wrote:
>>
>>> On Tue, Jan 07, 2014 at 05:44:26PM -0800, David Cohen wrote:
>>>> From: jianqian <jianqiang.tang@intel.com>
>>>>
>>>> There is a possible kernel panic faced on xhci_suspend().
>>>> Due to kernel modified the hub autosupend_delay to 0s, after usb1 root
>>>> hub finishes initialization, it will trigger runtime_suspend and then
>>>> it will trigger xhci runtime suspend. But at that time, if
>>>> xhci->shared_hcd is still doing initialization, it is possible to face
>>>> null pointer kernel panic in xhci_suspend() function.
>>>>
>>>> This patch checks if xhci->shared_hcd is null to avoid panic.
>>>
>>> That sounds like this is a race that should be fixed properly, not just
>>> papered over, right?
>>
>> That was my reaction too.  The best way to solve the problem is to
>> prevent the USB-2 root hub from suspending until after the USB-3 root
>> hub has been registered.
>
> That makes sense. Thanks for the feedback.
> I'll check for a new approach.
>

Could you check if this patch works for you?:

http://marc.info/?l=linux-usb&m=139298822514995&w=2

I'm not able to reproduce the original issue myself

-Mathias
