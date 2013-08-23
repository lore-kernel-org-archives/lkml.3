Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3HWSZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:25:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:65110 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab3HWSZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:25:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,943,1367996400"; 
   d="scan'208";a="350784758"
From: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Subject: RE: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type
 00 to PF Nacked" messages
Thread-Topic: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type
 00 to PF Nacked" messages
Thread-Index: AQHOmJVrwoQz29MPKEui5Cqk94n7XZmfOJuAgAAH/ICABEX4gP//ngZA
Date: Fri, 23 Aug 2013 18:25:06 +0000
Message-ID: <F6FB0E698C9B3143BDF729DF222866466FD4418D@ORSMSX110.amr.corp.intel.com>
References: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD41225@ORSMSX110.amr.corp.intel.com>
 <CAErSpo5AiRw7HvGQMq-n596ZkHJs_KJNn346yf+jc7yti-xpUw@mail.gmail.com>
 <CAErSpo4E9LNrfqTq1_WUoAx68_krw23BjSYbPpJPOr=zbq98xA@mail.gmail.com>
 <CAErSpo6Ky1FQeRjjbhja2KC7EYGJ2nR1ZNuYjYi89DoqLse2cw@mail.gmail.com>
 <CAErSpo7m=YB=1cHSBTwufTHAiAd+k9Re2s-ro509BELOgK8j7Q@mail.gmail.com>
In-Reply-To: <CAErSpo7m=YB=1cHSBTwufTHAiAd+k9Re2s-ro509BELOgK8j7Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Friday, August 23, 2013 9:53 AM
> To: Skidmore, Donald C
> Cc: e1000-devel@lists.sourceforge.net; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Don Dutile
> Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00
> to PF Nacked" messages
> 
> On Tue, Aug 20, 2013 at 5:37 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> > On Tue, Aug 20, 2013 at 5:08 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> >> On Tue, Aug 13, 2013 at 8:23 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> >
> >>> I played with this a little more and found this:
> >>>
> >>> 1) Magma card in z420, connected to chassis containing X540: fails
> >>> (original report)
> >>> 2) X540 in z420, Magma card in z420, connected to empty chassis:
> >>> fails
> >>> 3) X540 in z420, Magma card in z420 but no cable to chassis: works
> >
> > For what it's worth, I tried config 3 again with v3.11-rc6, and it
> > failed the same way.  I haven't bothered with config 2.  It's not 100%
> > reproducible, but at least it doesn't seem related to the expansion
> > chassis.
> >
> > I attached the logs from config 3 to
> > https://bugzilla.kernel.org/show_bug.cgi?id=60776
> 
> Is there anything I can do to help debug this?  Add instrumentation, etc.?  It
> seems like I'm doing the simplest possible thing -- just writing to the sysfs
> sriov_num_vfs file to enable VFs.
> 
> I almost think it must be related to my config somehow if nobody else is
> seeing this, but at the same time, my config also seems the simplest possible,
> so I don't know what I could be doing that's unusual.
> 
> Bjorn

Hey Bjorn,

I'm may be little confused so bear with me.

Option 1 = (your normal set up), Magma card plugged to chasis, X540 in chasis.
Option 2 = Magma card plugged to chasis, X540 in z420 system.
Option 3 = Magma card UNplugged from chasis, x540 in z420 system.

Options 1 & 2 - always fail
Option 3 - sometimes fails (unsure at what rate failure occurs)

Please correct me if I messed any of that up. :)

Another question I have relates to the lspci output you supplied in the bugzilla.  I'm not seeing the VF devices (i.e. 08:10.0) did you run lspci before you created the VF's?  If so could we see one while the failure was occurring?

Also could you download the latest ixgbevf from source forge?

https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/

If we add debugging messages it will be easier to patch this driver and it contains our latest validated code base.

Thanks,
-Don Skidmore <donald.c.skidmore@intel.com>



