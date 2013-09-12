Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3ILW06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:26:58 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39008 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3ILW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:26:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6pLsDTOPRgV0Qb3W9OSGZXkNOeBk+i47RyoFjK-xPEJw@mail.gmail.com>
References: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD41225@ORSMSX110.amr.corp.intel.com>
 <CAErSpo5AiRw7HvGQMq-n596ZkHJs_KJNn346yf+jc7yti-xpUw@mail.gmail.com>
 <CAErSpo4E9LNrfqTq1_WUoAx68_krw23BjSYbPpJPOr=zbq98xA@mail.gmail.com>
 <CAErSpo6Ky1FQeRjjbhja2KC7EYGJ2nR1ZNuYjYi89DoqLse2cw@mail.gmail.com>
 <CAErSpo7m=YB=1cHSBTwufTHAiAd+k9Re2s-ro509BELOgK8j7Q@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD4418D@ORSMSX110.amr.corp.intel.com>
 <20130823185240.GA1507@google.com> <F6FB0E698C9B3143BDF729DF222866466FD4421F@ORSMSX110.amr.corp.intel.com>
 <CAErSpo4VLBon21cSzaigVqy6dS7=qfVRuPTTGuWAz+GLJWmNog@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD44279@ORSMSX110.amr.corp.intel.com> <CAErSpo6pLsDTOPRgV0Qb3W9OSGZXkNOeBk+i47RyoFjK-xPEJw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 12 Sep 2013 16:26:34 -0600
Message-ID: <CAErSpo4LKRHyq=o5PC70heoiDiHOTvqzcML9F_OVwg+EtvUw6A@mail.gmail.com>
Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00
 to PF Nacked" messages
To: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
Cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 5:01 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> I haven't been able to reproduce the problem with the 2.10.3 ixgbevf
> driver from http://sourceforge.net/projects/e1000/files/ixgbevf%20stable/
> ...
> Sorry for wasting so much time on something that appears to be already fixed.

I just tried the brand-new v3.11, and the usual, trivial:

  # echo -n 8 > /sys/bus/pci/devices/0000:04:00.0/sriov_numvfs

was enough to blow up my box the same old boring way (infinite string
of "ixgbevf 0000:04:11.0: Last Request of type 03 to PF Nacked"
messages.

I guess this is because v3.11 still includes the 2.7.12-k ixgbevf
driver, not the apparently-fixed 2.10.3 version from your sourceforge
page.

According to sourceforge, 2.7.12 was released almost a YEAR ago, on
2012-10-18, and 2.10.3 was released 2013-07-26.  Why isn't 2.10.3 in
v3.11?

Don't you guys care that it is so easy to blow up your driver with the
mainline kernel?  I'm quite frustrated by how much time I've wasted on
this issue.

I do not think that defending yourself with "please try the latest
driver from sourceforge" is a reasonable or friendly way to work in
the Linux community.

Bjorn
