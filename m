Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaBCRFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:05:50 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38369 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaBCRFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:05:45 -0500
Message-ID: <52EFCC66.9020304@lwfinger.net>
Date: Mon, 03 Feb 2014 11:05:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>
CC: gregkh@linuxfoundation.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        Andrea Merello <andrea.merello@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>
Subject: Re: rtl8821ae.
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail> <20140202160512.GA4946@redhat.com> <201402021807.37772.s.L-H@gmx.de>
In-Reply-To: <201402021807.37772.s.L-H@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 12:07 PM, Stefan Lippers-Hollmann wrote:
> Hi
>
> [ CC'ing the relevant parties ]
>
> On Sunday 02 February 2014, Dave Jones wrote:
>> On Sun, Feb 02, 2014 at 03:41:27AM -0800, scan-admin@coverity.com wrote:
>>   >
>>   > Please find the latest report on new defect(s) introduced to Linux found with Coverity Scan.
>>   >
>>   > Defect(s) Reported-by: Coverity Scan
>>   > Showing 20 of 83 defect(s)
>>
>> Ugh, this is even worse than the usual realtek drivers. (With the exception of rtl8188eu)
>> All 83 of those new defects came from this new driver, and while there's
>> a bunch of "who cares" type things in there, there's a load of stuff that
>> needs fixing a lot more urgently than CodingStyle issues or anything else in the TODO
>> for that driver.
>>
>> A bigger problem though, is what is the plan for these realtek drivers ?
>> They've been in staging forever. rtl8187se has been there for _five_ years with
>> no indication it's ever getting promoted to first class status.
>
> Actually rtl8187se (aka rtl8185b) seems to have gotten some attention
> recently:
>
> http://lkml.kernel.org/r/CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com
>
>> The git logs are littered mostly with CodingStyle cleanups, sparse cleanups and such,
>> meanwhile for five years they've had out of bounds reads, overflows, and such
>> for this whole time.  Even worse, when one of the drivers gets fixes for actual
>> problems like this, they never make it back to Realtek, who clone the same
>> old shitty driver they shipped last time, and reintroduce new variants of the
>> same damn bugs, and then we import the new turd into staging and start all over again.
>>
>> I get the whole "a shit driver is better than no driver", but there's no discernable
>> effort to ever improve this pile, just to keep adding to it.
>>
>> 	Dave
>
> I think there are mostly two major problems with these drivers, besides
> RealTek still working on a non-mac80211 codebase for USB based devices.
>
> The sheer number of slightly different RealTek drivers for similar
> chipsets, for which RealTek as forked off a dedicated driver each,
> rather than extending the existing ones. With the other, probably even
> larger, problem being that it isn't possible to port wireless drivers
> from non-mac80111 to mac80211 in a gradual fashion, it's always a
> parallel re-implementation. Just look at the recent history of staging
> wireless drivers:
>
> the successful ones:
> - csr --> /dev/null
> - otus --> ar9170 --> carl9170
> - ( rt2870 && rt3070 ) --> rt2800usb
> - rt2870 --> rt2800pci
> - [ at76c503a --> ] at76_usb --> at76c50x-usb   [*] not in staging
>
> the pending ones
> - rtl8187se [ --> rtl8180 ]   [*] hopefully soon
> - rtl8188eu --> ?
> - [ rtl8192du --> ? ]   [*] not in staging, [1]
> - rtl8192e --> ?
> - rtl8192u --> ?
> - rtl8192su --> rtl8712 --> ? [ r92su[2] would add cfg80211 support,
>                                  but it being a fullmac like
>                                  re-implementation doesn't get it
>                                  anywhere ]
> - rtl8821ae [ --> mac80211 port planned for 3.15[3]? ]
>
> these devices are, besides rtl8187se (802.11g) and rtl8821ae
> (802.11ac), all 802.11n compatible, but were quickly EOLed by the
> vendor, probably making it hard to get enough traction for a proper
> mac80211 port. Coincidentally these chipsets are also very popular,
> rtl8187se being the chipset of the early netbook craze, rtl8188eu
> pretty ubiquitous on embedded platforms, the others making the bulk
> of aftermarket USB devices.
>
> ancient hardware, probably not going anywhere:
> - vt6655 --> ?
> - vt6656 --> ?
> - wlags49_h2 --> ?
> - wlags49_h25 --> ?
> - wlan-ng --> ?
>
> This likely leaves staging wireless drivers to small corrections and
> bugfixes. In the hope that the devices will get enough traction that
> someone takes up the effort of doing a parallel re-implementation of a
> proper mac80211 based driver, using the staging source only as
> reference.
>
> Regards
> 	Stefan Lippers-Hollmann
>
> [1]	https://github.com/lwfinger/rtl8192du
> [2]	https://github.com/chunkeey/rtl8192su/tree/master/r92su
> [3]	http://lkml.kernel.org/r/52E066A1.9010009@lwfinger.net
> 	http://lkml.kernel.org/r/52E7D9F6.5070402@lwfinger.net
>

There are many issues here. I will try to address them without writing something 
so long that no one reads it. Just to be clear, my work with Realtek drivers is 
as a volunteer and is done to provide a service to Linux users. The only thing I 
get from Realtek is advance copies of drivers (sometimes), and sample cards for 
PCI devices. With one exception, the USB devices in my possession have have been 
purchased with my own funds.

1. Coverity errors in rtl8821ae: This driver was added to staging with 
essentially no cleanup for several reasons. The first was as a favor to GregKH, 
Linus, and roughly 1000 other users who recently got this hardware and want a 
driver in 3.14. The second reason is that I do not yet have this hardware and 
did not want to make any changes as all testing would have to be conducted by 
Greg, and I think he has enough to do already. The driver uses mac80211, and it 
should be ready to be submitted to the regular tree in time for 3.15. Most of 
that cleanup has already been done. I should have sample hardware in the next 
few weeks for testing.

2. rtl8187se: Andrea Morello has done the port to mac80211. I have tested that 
version and found it stable. It should be in the regular wireless tree soon.

3. r8712u: This is the roughest of the drivers. As noted above, there is an 
ongoing effort to add cfg80211 capability, but not to convert it to mac80211. It 
is a softmac device, should be able to share code with rtl8192se, and it should 
be converted to mac80211. I have no idea if and when that will happen. I am busy 
with drivers for devices that are not otherwise supported in Linux. As to 
littering the git logs with cleanups for this driver, I am not doing such 
changes. I do not NACK other peoples efforts, but I do not participate.

4. Lack of response of Realtek to feedback: Development of drivers at Realtek is 
split into two groups. The one that works with PCI devices is in China. They 
have been very receptive to suggested changes, and I suspect that they study the 
versions that have been committed as I see their unprompted implementation of 
some of my changes. In addition, all new PCI-based drivers are mac80211 based. 
The USB group is in Taiwan. Despite my efforts, very few, if any, of my 
suggested changes have been adopted by them. None of their new drivers use mac80211.

5. Separate drivers for each chip: As I do not have, nor want, an NDA with 
Realtek, I have no knowledge of the internal workings of the chips. As such, it 
would be very difficult for me to write a combined driver for all the 802.11n 
chips. I do notice that there are fundamental differences such as different 
layouts of the DMA descriptors. A combined driver would require very many 
branches based on chip number and would certainly execute much more slowly.

6. Staging drivers rtl8192e and rtl8192u: These drivers predate any association 
I have with Realtek. In keeping with the Linux tradition of supporting old 
hardware, they probably need to be kept. Driver rtl8192e is particularly 
frustrating as it has a PCI ID in common with rtl8192ce. As the information 
needed to determine which driver applies cannot be read from the PCI interface, 
both drivers have to be loaded, tested, and the wrong one rejected late in the 
module probe code.

I am trying to improve the quality of this pile of ****, but I am only one 
person who was a life-long Fortran-coding scientist until I retired 15 years 
ago. Since then, I have been learning C and kernel-style coding practices. 
Certainly there is both a lot to do and a lot to learn.

Thanks for reading this far,

Larry

