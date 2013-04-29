Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab3D2VX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:23:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:25974 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab3D2VX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:23:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,576,1363158000"; 
   d="scan'208";a="328477565"
Date: Mon, 29 Apr 2013 14:23:50 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Fix racing for pci device removing via sysfs
Message-ID: <20130429212350.GA14978@xanatos>
References: <1366940841-15370-1-git-send-email-yinghai@kernel.org>
 <CAErSpo5zfHR-agNBdgqfVjCU+-KcTZV+1bvML5Uw-+icDqzzEA@mail.gmail.com>
 <CAE9FiQVEQO-dLJRjn9Z7JgwGWAn1M8S1Tn2_V0Fq+6kB0rG=Bg@mail.gmail.com>
 <CAErSpo7DUDQ_XgVKAfWxqYJA=q85ps46bffV-4a7b0vOzAP5DA@mail.gmail.com>
 <CAE9FiQWv-bN2XzHiQ0WU+Y678zcqs_Owua6vXXijdMO6=0OWpg@mail.gmail.com>
 <517E45C8.4060407@cn.fujitsu.com>
 <CAE9FiQUXxCH0xjFPk1S7e_JRsBPosqQ=N5Kpcrjp3RNWDh9yZQ@mail.gmail.com>
 <20130429181550.GA17343@google.com>
 <20130429182142.GA3385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429182142.GA3385@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:21:42AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Apr 29, 2013 at 11:15:50AM -0700, Bjorn Helgaas wrote:
> > On Mon, Apr 29, 2013 at 08:19:10AM -0700, Yinghai Lu wrote:
> > > On Mon, Apr 29, 2013 at 3:04 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> > > > On 04/27/2013 05:01 AM, Yinghai Lu wrote:
> > > >> On Fri, Apr 26, 2013 at 1:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > > >>>
> > > >>> You can't be serious.  This is a disgusting mess.  Checking a list
> > > >>> pointer for LIST_POISON1?  As far as I'm concerned, this is a waste of
> > > >>> my time.
> > > 
> > > looks like xhci is using that LIST_POISON1 ...
> > > 
> > Maybe my allergic reaction to your use of LIST_POISON1 is unjustified,
> > but I am dubious about the idea that xhci was the only place that needed
> > it before now, and we just happened to find one more place in PCI that
> > needs it.  That doesn't make sense because good design patterns are used
> > many times, not just once or twice.
> > 
> > I thought the whole point of the get/put scheme was that if we had a
> > pointer to a correctly reference-counted object, we didn't need to check
> > whether the object was still valid because the object remains valid until
> > all the references are released.
> 
> You are correct, you shouldn't have to worry about that.  If you have to
> do something like the LIST_POISON test, something is really wrong.

All right, I'll take a look at the xHCI code.  From a brief glance, both
places that use LIST_POISON are handling a timed-out command.  The
command handling in xHCI needs to get completely reworked anyway, due to
other race conditions.

Were you suggesting I use the get/put scheme in the xHCI driver, or was
that for Yinghai?

Sarah Sharp
