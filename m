Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3IZPcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:32:12 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52354 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3IZPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:32:11 -0400
Date: Thu, 26 Sep 2013 17:32:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andi Kleen <andi@firstfloor.org>, Lin Ming <minggr@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
Message-ID: <20130926153208.GN18242@two.firstfloor.org>
References: <20130913005133.GA32479@localhost>
 <20130913010936.GA1291@localhost>
 <5238767D.1080606@hurleysoftware.com>
 <20130917232214.GA11390@localhost>
 <5238F252.5070905@hurleysoftware.com>
 <CAF1ivSbYg296oHhO0_UXwkos8Ui_1C93pUnXPzow4qLWyAa2kg@mail.gmail.com>
 <5242C960.7050506@hurleysoftware.com>
 <1380124944.27676.1.camel@monkey32>
 <87r4cc8e0q.fsf@tassilo.jf.intel.com>
 <52441FF7.1030405@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52441FF7.1030405@hurleysoftware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 07:52:23AM -0400, Peter Hurley wrote:
> On 09/25/2013 11:20 PM, Andi Kleen wrote:
> >Lin Ming <minggr@gmail.com> writes:
> >>
> >>Would you like below patch?
> >
> >The loop body keeps rather complex state. It could easily
> >get confused by parallel RCU changes.
> >
> >So if the list changes in parallel you may suddenly
> >report very bogus values, as the va_start - prev_end
> >computation may be bogus.
> >
> >Perhaps it's ok (may report bogus gaps), but it seems a bit risky.
> 
> I don't understand how the computed gap would be bogus; there
> _was_ a list state in which that particular gap existed. The fact

It could change any time as you don't have an atomic view
of vm_end / vm_start. It is valid to change the fields
with the lock held.

-Andi
