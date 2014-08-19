Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaHSFcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:32:46 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:43587 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaHSFcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140818212116.GD24023@mtj.dyndns.org>
References: <CAEuXFEy5=0XkqPiWQNiGbpi5EHSzq5f_U7Sj0t2bhO_1Lqe5vw@mail.gmail.com>
	<53CEBFF2.7050100@hurleysoftware.com>
	<20140723083937.GA3416@twins.programming.kicks-ass.net>
	<CAPDOMVgjPyqTrk2YTQFufdQzeKBS5bgnWSqNJCqutxFV=fNz8Q@mail.gmail.com>
	<20140818212116.GD24023@mtj.dyndns.org>
Date: Mon, 18 Aug 2014 22:32:44 -0700
Message-ID: <CAPcyv4gQp0==48=Ed3X1DG2i0okqWrq7vUumMfTFYOMF9EgW2A@mail.gmail.com>
Subject: Re: PANIC: ata_qc_new_init crashes at boot
From: Dan Williams <dan.j.williams@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Nick Krause <xerofoify@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 2:21 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Sorry about the delay.  Cc'ing Dan.
>
> On Wed, Aug 06, 2014 at 02:02:47PM -0400, Nick Krause wrote:
>> On Wed, Jul 23, 2014 at 4:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, Jul 22, 2014 at 03:48:02PM -0400, Peter Hurley wrote:
>> >> [ +cc Tejun ]
>> >>
>> >> On 07/22/2014 03:26 PM, Jesse Brandeburg wrote:
>> >> > This is a repeatable panic, happens every boot (and prevents starting my system)
>> >> >
>> >> > [    8.732993] sd 6:0:1:0: [sdb] Attached SCSI disk
>> >> > [    8.733857]  sda: sda1 sda2 sda3
>> >> > [    8.734318] sd 6:0:0:0: [sda] Attached SCSI disk
>> >> > [    8.737943] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
>> >> > [    8.737947] IP: [<ffffffff814e0618>] ata_qc_new_init+0x188/0x1b0
>> >
>> > I too have this problem on one of my machines. Let me know if there's
>> > anything you need.
>
> Are you still seeing this on every boot?  ISTR this getting fixed but
> I could be confused.  Dan, the original thread is
>
>   http://lkml.kernel.org/g/CAEuXFEy5=0XkqPiWQNiGbpi5EHSzq5f_U7Sj0t2bhO_1Lqe5vw@mail.gmail.com
>

This is the last I heard:

http://marc.info/?l=linux-ide&m=140630768020241&w=2

But I never saw a follow up.

Hmmm, commit 1a112d10f03e libata: introduce ata_host->n_tags to avoid
oops on SAS controllers

...doesn't fix this?  Jesse reported positive results here:

http://marc.info/?l=linux-ide&m=140624094731542&w=2
