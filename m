Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3CKMRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:17:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3CKMRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:17:51 -0400
Message-ID: <513DCB65.3010301@redhat.com>
Date: Mon, 11 Mar 2013 08:17:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Myron Stowe <myron.stowe@gmail.com>, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com> <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com> <20130309204940.GA31808@neilslaptop.think-freely.org> <CAL-B5D15YY6L01q6BCNnP5VCJN7=LeHJSYLjNGXZPRx7VhsZCg@mail.gmail.com> <20130311112500.GA12682@hmsreliant.think-freely.org>
In-Reply-To: <20130311112500.GA12682@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 07:25 AM, Neil Horman wrote:
> On Sat, Mar 09, 2013 at 03:20:57PM -0700, Myron Stowe wrote:
>> On Sat, Mar 9, 2013 at 1:49 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>>> On Mon, Mar 04, 2013 at 02:04:19PM -0500, Neil Horman wrote:
>>>> A few years back intel published a spec update:
>>>> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
>>>>
>>>> For the 5520 and 5500 chipsets which contained an errata (specificially errata
>>>> 53), which noted that these chipsets can't properly do interrupt remapping, and
>>>> as a result the recommend that interrupt remapping be disabled in bios.  While
>>>> many vendors have a bios update to do exactly that, not all do, and of course
>>>> not all users update their bios to a level that corrects the problem.  As a
>>>> result, occasionally interrupts can arrive at a cpu even after affinity for that
>>>> interrupt has be moved, leading to lost or spurrious interrupts (usually
>>>> characterized by the message:
>>>> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
>>>>
>>>> There have been several incidents recently of people seeing this error, and
>>>> investigation has shown that they have system for which their BIOS level is such
>>>> that this feature was not properly turned off.  As such, it would be good to
>>>> give them a reminder that their systems are vulnurable to this problem.
>>>>
>>>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>>>> CC: Prarit Bhargava <prarit@redhat.com>
>>>> CC: Don Zickus <dzickus@redhat.com>
>>>> CC: Don Dutile <ddutile@redhat.com>
>>>> CC: Bjorn Helgaas <bhelgaas@google.com>
>>>> CC: Asit Mallick <asit.k.mallick@intel.com>
>>>> CC: linux-pci@vger.kernel.org
>>>>
>>> Ping, anyone want to Ack/Nack this?
>>
>> Don's comment earlier seems to imply that this is a short term fix and
>> that a more long term fix may be coming soon.  If that is the case
>> wouldn't we want to wait for the long term fix and just pull that in?
>>
>> Myron
>>
> As Don and Prarit have mentioned, an alternate change is being worked on and
> tested that may work around this issue, but we're not yet sure that it will, and
> we're not sure of the time frame for this fix.  Normally I would agree, that it
> would be easier just to wait for the long term fix, but as Prarit noted, since
> this hardware is in fact broken, I would rather do a both approach.  Its fine if
> this gets reverted tomorrow with a longer term fix as far as I'm concerned, its
> just caused enough problems already that I'd like to see it in place until the
> better solution arrives.

I agree with Neil on this.  While vendors are supposed to fix their BIOSes,
experience has shown that not all vendors will fix their BIOSes for a problem
like this.

Ack this quirk.

P.

> Neil
>  
> 

