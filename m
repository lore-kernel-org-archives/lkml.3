Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab3IMASa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:18:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:1987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3IMASV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,894,1371106800"; 
   d="scan'208";a="402610773"
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
Thread-Index: AQHOmJVrwoQz29MPKEui5Cqk94n7XZmfOJuAgAAH/ICABEX4gP//ngZAgACDewD//6ZTMIAAeG6A//+YeXAD7722fAABgkpA
Date: Fri, 13 Sep 2013 00:18:19 +0000
Message-ID: <F6FB0E698C9B3143BDF729DF222866466FD547F0@ORSMSX110.amr.corp.intel.com>
References: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD41225@ORSMSX110.amr.corp.intel.com>
 <CAErSpo5AiRw7HvGQMq-n596ZkHJs_KJNn346yf+jc7yti-xpUw@mail.gmail.com>
 <CAErSpo4E9LNrfqTq1_WUoAx68_krw23BjSYbPpJPOr=zbq98xA@mail.gmail.com>
 <CAErSpo6Ky1FQeRjjbhja2KC7EYGJ2nR1ZNuYjYi89DoqLse2cw@mail.gmail.com>
 <CAErSpo7m=YB=1cHSBTwufTHAiAd+k9Re2s-ro509BELOgK8j7Q@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD4418D@ORSMSX110.amr.corp.intel.com>
 <20130823185240.GA1507@google.com>
 <F6FB0E698C9B3143BDF729DF222866466FD4421F@ORSMSX110.amr.corp.intel.com>
 <CAErSpo4VLBon21cSzaigVqy6dS7=qfVRuPTTGuWAz+GLJWmNog@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD44279@ORSMSX110.amr.corp.intel.com>
 <CAErSpo6pLsDTOPRgV0Qb3W9OSGZXkNOeBk+i47RyoFjK-xPEJw@mail.gmail.com>
 <CAErSpo4LKRHyq=o5PC70heoiDiHOTvqzcML9F_OVwg+EtvUw6A@mail.gmail.com>
In-Reply-To: <CAErSpo4LKRHyq=o5PC70heoiDiHOTvqzcML9F_OVwg+EtvUw6A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Thursday, September 12, 2013 3:27 PM
> To: Skidmore, Donald C
> Cc: e1000-devel@lists.sourceforge.net; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Don Dutile
> Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00
> to PF Nacked" messages
> 
> On Tue, Aug 27, 2013 at 5:01 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> 
> > I haven't been able to reproduce the problem with the 2.10.3 ixgbevf
> > driver from
> > http://sourceforge.net/projects/e1000/files/ixgbevf%20stable/
> > ...
> > Sorry for wasting so much time on something that appears to be already
> fixed.
> 
> I just tried the brand-new v3.11, and the usual, trivial:
> 
>   # echo -n 8 > /sys/bus/pci/devices/0000:04:00.0/sriov_numvfs
> 
> was enough to blow up my box the same old boring way (infinite string of
> "ixgbevf 0000:04:11.0: Last Request of type 03 to PF Nacked"
> messages.
> 
> I guess this is because v3.11 still includes the 2.7.12-k ixgbevf driver, not the
> apparently-fixed 2.10.3 version from your sourceforge page.
> 
> According to sourceforge, 2.7.12 was released almost a YEAR ago, on 2012-10-
> 18, and 2.10.3 was released 2013-07-26.  Why isn't 2.10.3 in v3.11?
> 
> Don't you guys care that it is so easy to blow up your driver with the mainline
> kernel?  I'm quite frustrated by how much time I've wasted on this issue.
> 
> I do not think that defending yourself with "please try the latest driver from
> sourceforge" is a reasonable or friendly way to work in the Linux community.
> 
> Bjorn

Your right I haven't been keeping the version strings up-to-date with our latest upstream pushes.  I was hoping to reach a sync point were both drivers (upstream and out of tree) were closer before I bumped the upstream version.  The relationship between the version number in the ixgbevf version number in the upstream kernel and our out of tree driver are not quite that straight forward as the version strings would suggest.  We have pushed quite a few patches since the last version bump a year ago and in fact attempt to push patches upstream in parallel with any changes we make in the out of tree driver.   But depending on quite a list of events (testing, release schedule, when net-next is open) one driver can receive patches earlier and or later than another.  Also ixgbevf is currently going through a fair amount of refactoring to bring in more up to date with ixgbe so there are a fair amount of patches currently in play. The reason I suggested you try the out of tree driver (source forge) as I knew it was currently a bit more up to date. 

The good news is if the latest out of tree driver is correcting your problem the fix most likely is reroute to upstream.  Likewise I can send you some of the upstream patches that are in the out of tree driver but are waiting to be sent upstream, if you would like to try them.  Some of them touch code around the mbx messages, which like I mentioned in an early email the error message your seeing seems to imply something has gone wrong there.  But since we can't seem to recreate your failure local I can't know for sure.

Thanks,
-Don Skidmore <donald.c.skidmore@intel.com>


