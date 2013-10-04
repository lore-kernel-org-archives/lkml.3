Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3JDUzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:55:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:43747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab3JDUzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:55:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414174602"
Message-ID: <524F2B4C.7080702@linux.intel.com>
Date: Fri, 04 Oct 2013 13:55:40 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>, Arjan van de Ven <arjan@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 3/6] PowerCap: Added to drivers build
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com> <201310041524.20634.gheskett@wdtv.com> <524F192A.7050908@linux.intel.com> <201310041622.29259.gheskett@wdtv.com>
In-Reply-To: <201310041622.29259.gheskett@wdtv.com>
Content-Type: text/plain; charset=windows-1256; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 01:22 PM, Gene Heskett wrote:
> On Friday 04 October 2013, Srinivas Pandruvada wrote:
>> On 10/04/2013 12:24 PM, Gene Heskett wrote:
>>> On Friday 04 October 2013, Srinivas Pandruvada wrote:
>>>> Added changes to Makefile and Kconfig to include in driver build.
>>>>
>>>> Signed-off-by: Srinivas Pandruvada
>>>> <srinivas.pandruvada@linux.intel.com> Signed-off-by: Jacob Pan
>>>> <jacob.jun.pan@linux.intel.com>
>>>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>> ---
>>>> drivers/Kconfig  | 2 ++
>>>> drivers/Makefile | 1 +
>>>> 2 files changed, 3 insertions(+)
>>>>
>>>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>>>> index aa43b91..969e987 100644
>>>> --- a/drivers/Kconfig
>>>> +++ b/drivers/Kconfig
>>>> @@ -166,4 +166,6 @@ source "drivers/reset/Kconfig"
>>>>
>>>> source "drivers/fmc/Kconfig"
>>>>
>>>> +source "drivers/powercap/Kconfig"
>>>> +
>>>> endmenu
>>>> diff --git a/drivers/Makefile b/drivers/Makefile
>>>> index ab93de8..34c1d55 100644
>>>> --- a/drivers/Makefile
>>>> +++ b/drivers/Makefile
>>>> @@ -152,3 +152,4 @@ obj-$(CONFIG_VME_BUS)		+= vme/
>>>> obj-$(CONFIG_IPACK_BUS)		+= ipack/
>>>> obj-$(CONFIG_NTB)		+= ntb/
>>>> obj-$(CONFIG_FMC)		+= fmc/
>>>> +obj-$(CONFIG_POWERCAP)		+= powercap/
>>> I would object to this whole premise if it is not under the absolute
>>> control of the users program. Linuxcnc for instance is intimately
>>> married to a parport whose status for writes is absolutely stable from
>>> write to write, and whose status may be in some cases, read at sub 20
>>> u-second intervals.  Anything which would imped this, puts the
>>> operator of a 50+ ton piece of machinery's life in jeopardy because
>>> its status is not readable in as close to real time as possible as it
>>> may be required to initiate a stop from some alarm condition before it
>>> has moved far enough to injure, maim or kill. 50 thousandths of an
>>> inch in further movement while moving a 70 ton milling machines table
>>> at 150 inches a minute is not an unreasonable expectation for us.
>> <Sorry, I didn't understand. Are you pointing any problem in this patch
>> or patch-set in general?
> Not that my relatively untrained eyes can spot.
>
>> This change added powercap directory to the kernel build. Is something
>> wrong with it or any other way to do that?
> The prospect of having a poorly configured way to power down a port that is
> running heavy machinery under real time control scares me.  And that is
> what this patch series seems to be leading up to if I am reading the patch
> headers correctly.  If I am not reading it correctly, then assume I am
> issuing a pre-emptive strike just to make sure you folks trying to save a
> milliwatt here and there, and there is not a thing wrong with the basic
> idea, are made aware of the potential for maiming mischief should you
> decide to power down a port just because its last access was 5 milliseconds
> ago.  Even a completely servo driven configuration will tickle it faster
> than that, however an e-stop condition, which might shut down a charge pump
> pulse generator must be maintained until cleared by the operator, which
> means the control channel to the machine, whatever port it is, must be kept
> alive to be human safe around the machine.  The capability to do that to a
> given port should therefore be made a kernel .config selection incapable of
> being overridden by some other perceived dependency in kconfig.
>
> I hope this is a better explanation. :)
The idea of power capping is to cap total power not power down and also 
need root level access to modify.
There is a minimum and maximum values is also defined, which should make 
sure that the system is
running with reduced performance, not power down.
This patch is not affecting Linux PM. Power down a port trigger 
generated by PM framework in coordination
with the driver controlling the port.
If some port is capable of powercapping and implemented a client driver 
for this, they can disable the whole
power capping by setting CONFIG_POWERCAP=n for such systems.
> And please, lets keep such discussion on the list where it belongs.
>
I am still doing reply to all to keep everyone in the mailing list in loop.



Thanks,
Srinivas
