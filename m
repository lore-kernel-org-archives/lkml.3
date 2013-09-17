Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3IQC4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 22:56:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:7162 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab3IQC4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 22:56:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,920,1371106800"; 
   d="scan'208";a="396732890"
Date: Tue, 17 Sep 2013 10:56:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
Message-ID: <20130917025642.GA29664@localhost>
References: <20130913005133.GA32479@localhost>
 <20130913031700.GB23757@kroah.com>
 <20130913033803.GB8704@localhost>
 <5237C183.7040308@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237C183.7040308@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:42:11PM -0400, Peter Hurley wrote:
> On 09/12/2013 11:38 PM, Fengguang Wu wrote:
> >On Thu, Sep 12, 2013 at 08:17:00PM -0700, Greg KH wrote:
> >>On Fri, Sep 13, 2013 at 08:51:33AM +0800, Fengguang Wu wrote:
> >>>Hi Peter,
> >>>
> >>>FYI, we noticed much increased vmap_area_lock contentions since this
> >>>commit:
> >>
> >>What does that mean?  What is happening, are we allocating/removing more
> >>memory now?
> >
> >// leave this question to Peter and Tejun. :)
> >
> >>What type of load were you running that showed this problem?
> >
> >The increased contentions and lock hold/wait time showed up in a
> >number of test cases.
> 
> How is the raw data acquired?
> 
> For example, is the test apparatus reading from /proc/vmallocinfo
> (which claims the vmap_area_lock) during the test execution?

We didn't read /proc/vmallocinfo and read /proc/lock_stat once when
the test ends.

> I'm wondering if a Heisenberg effect is happening here.

Thanks,
Fengguang
