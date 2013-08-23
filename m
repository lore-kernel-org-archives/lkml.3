Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3HWUnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:43:09 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62261 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab3HWUnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:43:07 -0400
MIME-Version: 1.0
In-Reply-To: <F6FB0E698C9B3143BDF729DF222866466FD4421F@ORSMSX110.amr.corp.intel.com>
References: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD41225@ORSMSX110.amr.corp.intel.com>
 <CAErSpo5AiRw7HvGQMq-n596ZkHJs_KJNn346yf+jc7yti-xpUw@mail.gmail.com>
 <CAErSpo4E9LNrfqTq1_WUoAx68_krw23BjSYbPpJPOr=zbq98xA@mail.gmail.com>
 <CAErSpo6Ky1FQeRjjbhja2KC7EYGJ2nR1ZNuYjYi89DoqLse2cw@mail.gmail.com>
 <CAErSpo7m=YB=1cHSBTwufTHAiAd+k9Re2s-ro509BELOgK8j7Q@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD4418D@ORSMSX110.amr.corp.intel.com>
 <20130823185240.GA1507@google.com> <F6FB0E698C9B3143BDF729DF222866466FD4421F@ORSMSX110.amr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 23 Aug 2013 14:42:45 -0600
Message-ID: <CAErSpo4VLBon21cSzaigVqy6dS7=qfVRuPTTGuWAz+GLJWmNog@mail.gmail.com>
Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00
 to PF Nacked" messages
To: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
Cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 2:37 PM, Skidmore, Donald C
<donald.c.skidmore@intel.com> wrote:
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Friday, August 23, 2013 11:53 AM
>> To: Skidmore, Donald C
>> Cc: e1000-devel@lists.sourceforge.net; linux-pci@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Don Dutile
>> Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00
>> to PF Nacked" messages
>>
>> On Fri, Aug 23, 2013 at 06:25:06PM +0000, Skidmore, Donald C wrote:
>> > > -----Original Message-----
>> > > From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> > > Sent: Friday, August 23, 2013 9:53 AM
>> > > To: Skidmore, Donald C
>> > > Cc: e1000-devel@lists.sourceforge.net; linux-pci@vger.kernel.org;
>> > > linux- kernel@vger.kernel.org; Don Dutile
>> > > Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request
>> > > of type 00 to PF Nacked" messages
>> > >
>> > > On Tue, Aug 20, 2013 at 5:37 PM, Bjorn Helgaas <bhelgaas@google.com>
>> > > wrote:
>> > > > On Tue, Aug 20, 2013 at 5:08 PM, Bjorn Helgaas
>> > > > <bhelgaas@google.com>
>> > > wrote:
>> > > >> On Tue, Aug 13, 2013 at 8:23 PM, Bjorn Helgaas
>> > > >> <bhelgaas@google.com>
>> > > wrote:
>> > > >
>> > > >>> I played with this a little more and found this:
>> > > >>>
>> > > >>> 1) Magma card in z420, connected to chassis containing X540:
>> > > >>> fails (original report)
>> > > >>> 2) X540 in z420, Magma card in z420, connected to empty chassis:
>> > > >>> fails
>> > > >>> 3) X540 in z420, Magma card in z420 but no cable to chassis:
>> > > >>> works
>> > > >
>> > > > For what it's worth, I tried config 3 again with v3.11-rc6, and it
>> > > > failed the same way.  I haven't bothered with config 2.  It's not
>> > > > 100% reproducible, but at least it doesn't seem related to the
>> > > > expansion chassis.
>> > > >
>> > > > I attached the logs from config 3 to
>> > > > https://bugzilla.kernel.org/show_bug.cgi?id=60776
>> > >
>> > > Is there anything I can do to help debug this?  Add instrumentation,
>> > > etc.?  It seems like I'm doing the simplest possible thing -- just
>> > > writing to the sysfs sriov_num_vfs file to enable VFs.
>> > >
>> > > I almost think it must be related to my config somehow if nobody
>> > > else is seeing this, but at the same time, my config also seems the
>> > > simplest possible, so I don't know what I could be doing that's unusual.
>> > >
>> > > Bjorn
>> >
>> > Hey Bjorn,
>> >
>> > I'm may be little confused so bear with me.
>> >
>> > Option 1 = (your normal set up), Magma card plugged to chasis, X540 in
>> chasis.
>> > Option 2 = Magma card plugged to chasis, X540 in z420 system.
>> > Option 3 = Magma card UNplugged from chasis, x540 in z420 system.
>> >
>> > Options 1 & 2 - always fail
>> > Option 3 - sometimes fails (unsure at what rate failure occurs)
>> >
>> > Please correct me if I messed any of that up. :)
>>
>> Generally correct.  I've seen failures in all three configs, so I'm only
>> concerned with the simplest for now (config 3, no expansion chassis).
>>
>> > Another question I have relates to the lspci output you supplied in the
>> bugzilla.  I'm not seeing the VF devices (i.e. 08:10.0) did you run lspci before
>> you created the VF's?  If so could we see one while the failure was occurring?
>>
>> That's correct, I collected the lspci output before reproducing the problem.  I
>> can't easily collect lspci afterwards because the machine isn't responsive
>> after the problem starts.
>>
>> > Also could you download the latest ixgbevf from source forge?
>> >
>> > https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/
>> >
>> > If we add debugging messages it will be easier to patch this driver and it
>> contains our latest validated code base.
>>
>> I can do that if it turns out to be necessary.  But John Haller gave me a good
>> clue off-list:
>>
>> John wrote:
>> > I assume you want the VFs to be instantiated in a VM.  To do this, you
>> > need to blacklist the ixgbevf driver in the host (or not compile it
>> > into the host), or it will try to associate the driver in the host,
>> > rather than in the VM where you want it.  Then, the VM needs the
>> > ixgbevf driver, which will hopefully do a better job of talking to the
>> > mailbox in the host.  There is some work to assign the VF(s) to the
>> > VM, but I don't remember that offhand.
>>
>> I don't have any VMs (I started this whole thing because I was looking at a PCI
>> hotplug issue related to SR-IOV, so I don't really care about VMs).
>>
>> So the ixgbevf driver on the *host* is claiming the new VFs, and it sounds like
>> maybe it can't handle that?
>>
>> Bjorn
>
> Not to speak for John, but I believe he was saying if you want to use your VF's in a VM you need to make sure you don't run the ixgbevf driver on the host as it will "claim" the VF's.  If you are NOT running any VM's then it is perfectly fine to have both ixgbe and ixgbevf loaded.

OK.  It certainly *seemed* surprising to have the ixgbevf driver blow
up, even if it was an error on my part to load it in the host.  Just
let me know if there's any more testing I can do.

Bjorn
