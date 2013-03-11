Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3CKBcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:32:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab3CKBcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:32:16 -0400
Message-ID: <513D340E.5030908@redhat.com>
Date: Sun, 10 Mar 2013 21:31:58 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@gmail.com>
CC: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com> <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com> <20130309204940.GA31808@neilslaptop.think-freely.org> <CAL-B5D15YY6L01q6BCNnP5VCJN7=LeHJSYLjNGXZPRx7VhsZCg@mail.gmail.com>
In-Reply-To: <CAL-B5D15YY6L01q6BCNnP5VCJN7=LeHJSYLjNGXZPRx7VhsZCg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 05:20 PM, Myron Stowe wrote:
> On Sat, Mar 9, 2013 at 1:49 PM, Neil Horman<nhorman@tuxdriver.com>  wrote:
>> On Mon, Mar 04, 2013 at 02:04:19PM -0500, Neil Horman wrote:
>>> A few years back intel published a spec update:
>>> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
>>>
>>> For the 5520 and 5500 chipsets which contained an errata (specificially errata
>>> 53), which noted that these chipsets can't properly do interrupt remapping, and
>>> as a result the recommend that interrupt remapping be disabled in bios.  While
>>> many vendors have a bios update to do exactly that, not all do, and of course
>>> not all users update their bios to a level that corrects the problem.  As a
>>> result, occasionally interrupts can arrive at a cpu even after affinity for that
>>> interrupt has be moved, leading to lost or spurrious interrupts (usually
>>> characterized by the message:
>>> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
>>>
>>> There have been several incidents recently of people seeing this error, and
>>> investigation has shown that they have system for which their BIOS level is such
>>> that this feature was not properly turned off.  As such, it would be good to
>>> give them a reminder that their systems are vulnurable to this problem.
>>>
>>> Signed-off-by: Neil Horman<nhorman@tuxdriver.com>
>>> CC: Prarit Bhargava<prarit@redhat.com>
>>> CC: Don Zickus<dzickus@redhat.com>
>>> CC: Don Dutile<ddutile@redhat.com>
>>> CC: Bjorn Helgaas<bhelgaas@google.com>
>>> CC: Asit Mallick<asit.k.mallick@intel.com>
>>> CC: linux-pci@vger.kernel.org
>>>
>> Ping, anyone want to Ack/Nack this?
>
> Don's comment earlier seems to imply that this is a short term fix and
> that a more long term fix may be coming soon.  If that is the case
> wouldn't we want to wait for the long term fix and just pull that in?
>
> Myron
>
At the time of Neil's postings, multiple changes were being considered,
and we didn't know how long it would take to verify any one change.
Thus, Neil's patch was proposed to identify a known problem that was
being seen on multiple systems, and it was proposed so further
system issues wouldn't go mis-diagnosed.

We are still testing a minor change, and test results are positive so far.
After we're sure of its logic as it's results, it can be posted and
this patch can be removed if it is taken before we are certain.

As Prarit stated, we should be sure of changes in this area before
throwing this patch away for an option that could yield other failures.

- Don
>> Neil
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

