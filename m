Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaFLPc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbaFLPc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:32:56 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Felipe Franciosi <felipe.franciosi@citrix.com>
Cc: Roger Pau Monne <roger.pau@citrix.com>,
        "xen-devel\@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "axboe\@kernel.dk" <axboe@kernel.dk>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "jerry.snitselaar\@oracle.com" <jerry.snitselaar@oracle.com>,
        Jiri Slaby <jslaby@suse.cz>, Ronen Hod <rhod@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [Xen-devel] Backport request to stable of two performance related fixes for xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com>
	<20140604054848.GA20895@kroah.com> <53919C2B.6080606@suse.cz>
	<87mwdqjodv.fsf@vitty.brq.redhat.com>
	<874mzshph4.fsf@vitty.brq.redhat.com> <53973867.7050004@citrix.com>
	<87ha3qcp6y.fsf@vitty.brq.redhat.com>
	<9F2C4E7DFB7839489C89757A66C5AD6267E138@AMSPEX01CL03.citrite.net>
Date: Thu, 12 Jun 2014 17:32:40 +0200
In-Reply-To: <9F2C4E7DFB7839489C89757A66C5AD6267E138@AMSPEX01CL03.citrite.net>
	(Felipe Franciosi's message of "Thu, 12 Jun 2014 12:32:15 +0000")
Message-ID: <87d2eecfdz.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Franciosi <felipe.franciosi@citrix.com> writes:

> Hi Vitaly,
>
> Are you able to test a 3.10 guest with and without the backport that
> Roger sent? This patch is attached to an e-mail Roger sent on "22 May
> 2014 13:54".

Sure,

Now I'm comparing d642daf637d02dacf216d7fd9da7532a4681cfd3 and
46c0326164c98e556c35c3eb240273595d43425d commits from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
(with and without two commits in question). The test is exactly the same
as described before.

The result is here:
http://hadoop.ru/pubfiles/bug1096909/fusion/310_nopgrants_stripe.png

as you can see 46c03261 (without patches) wins everywhere.

>
> Because your results are contradicting with what these patches are
> meant to do, I would like to make sure that this isn't related to
> something else that happened after 3.10.

I still think Dom0 kernel and blktap/blktap3 is what make a difference
between our test environments.

>
> You could also test Ubuntu Sancy guests with and without the patched kernels provided by Joseph Salisbury on launchpad: https://bugs.launchpad.net/bugs/1319003
>
> Thanks,
> Felipe
>
>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: 12 June 2014 13:01
>> To: Roger Pau Monne
>> Cc: xen-devel@lists.xenproject.org; axboe@kernel.dk; Felipe Franciosi; Greg
>> KH; linux-kernel@vger.kernel.org; stable@vger.kernel.org;
>> jerry.snitselaar@oracle.com; Jiri Slaby; Ronen Hod; Andrew Jones
>> Subject: Re: [Xen-devel] Backport request to stable of two performance
>> related fixes for xen-blkfront (3.13 fixes to earlier trees)
>> 
>> Roger Pau Monné <roger.pau@citrix.com> writes:
>> 
>> > On 10/06/14 15:19, Vitaly Kuznetsov wrote:
>> >> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> >>
>> >>> Jiri Slaby <jslaby@suse.cz> writes:
>> >>>
>> >>>> On 06/04/2014 07:48 AM, Greg KH wrote:
>> >>>>> On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk
>> wrote:
>> >>>>>> Hey Greg
>> >>>>>>
>> >>>>>> This email is in regards to backporting two patches to stable
>> >>>>>> that fall under the 'performance' rule:
>> >>>>>>
>> >>>>>>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>> >>>>>>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
>> >>>>>
>> >>>>> Now queued up, thanks.
>> >>>>
>> >>>> AFAIU, they introduce a performance regression.
>> >>>>
>> >>>> Vitaly?
>> >>>
>> >>> I'm aware of a performance regression in a 'very special' case when
>> >>> ramdisks or files on tmpfs are being used as storage, I post my
>> >>> results a while ago:
>> >>> https://lkml.org/lkml/2014/5/22/164
>> >>> I'm not sure if that 'special' case requires investigation and/or
>> >>> should prevent us from doing stable backport but it would be nice if
>> >>> someone tries to reproduce it at least.
>> >>>
>> >>> I'm going to make a bunch of tests with FusionIO drives and
>> >>> sequential read to replicate same test Felipe did, I'll report as
>> >>> soon as I have data (beginning of next week hopefuly).
>> >>
>> >> Turns out the regression I'm observing with these patches is not
>> >> restricted to tmpfs/ramdisk usage.
>> >>
>> >> I was doing tests with Fusion-io ioDrive Duo 320GB (Dual Adapter) on
>> >> HP ProLiant DL380 G6 (2xE5540, 8G RAM). Hyperthreading is disabled,
>> >> Dom0 is pinned to CPU0 (cores 0,1,2,3) I run up to 8 guests with 1
>> >> vCPU each, they are pinned to CPU1 (cores 4,5,6,7,4,5,6,7). I tried
>> >> differed pinning (Dom0 to 0,1,4,5, DomUs to 2,3,6,7,2,3,6,7 to
>> >> balance NUMA, that doesn't make any difference to the results). I was
>> >> testing on top of Xen-4.3.2.
>> >>
>> >> I was testing two storage configurations:
>> >> 1) Plain 10G partitions from one Fusion drive (/dev/fioa) are
>> >> attached to guests
>> >> 2) LVM group is created on top of both drives (/dev/fioa, /dev/fiob),
>> >> 10G logical volumes are created with striping (lvcreate -i2 ...)
>> >>
>> >> Test is done by simultaneous fio run in guests (rw=read, direct=1)
>> >> for
>> >> 10 second. Each test was performed 3 times and the average was taken.
>> >> Kernels I compare are:
>> >> 1) v3.15-rc5-157-g60b5f90 unmodified
>> >> 2) v3.15-rc5-157-g60b5f90 with
>> 427bfe07e6744c058ce6fc4aa187cda96b635539,
>> >>    bfe11d6de1c416cea4f3f0f35f864162063ce3fa, and
>> >>    fbe363c476afe8ec992d3baf682670a4bd1b6ce6 reverted.
>> >>
>> >> First test was done with Dom0 with persistent grant support (Fedora's
>> >> 3.14.4-200.fc20.x86_64):
>> >> 1) Partitions:
>> >> http://hadoop.ru/pubfiles/bug1096909/fusion/315_pgrants_partitions.pn
>> >> g (same markers mean same bs, we get 860 MB/s here, patches make no
>> >> difference, result matches expectation)
>> >>
>> >> 2) LVM Stripe:
>> >> http://hadoop.ru/pubfiles/bug1096909/fusion/315_pgrants_stripe.png
>> >> (1715 MB/s, patches make no difference, result matches expectation)
>> >>
>> >> Second test was performed with Dom0 without persistent grants support
>> >> (Fedora's 3.7.9-205.fc18.x86_64)
>> >> 1) Partitions:
>> >> http://hadoop.ru/pubfiles/bug1096909/fusion/315_nopgrants_partitions.
>> >> png
>> >> (860 MB/sec again, patches worsen a bit overall throughput with 1-3
>> >> clients)
>> >>
>> >> 2) LVM Stripe:
>> >> http://hadoop.ru/pubfiles/bug1096909/fusion/315_nopgrants_stripe.png
>> >> (Here we see the same regression I observed with ramdisks and tmpfs
>> >> files, unmodified kernel: 1550MB/s, with patches reverted: 1715MB/s).
>> >>
>> >> The only major difference with Felipe's test is that he was using
>> >> blktap3 with XenServer and I'm using standard blktap2.
>> >
>> > Hello,
>> >
>> > I don't think you are using blktap2, I guess you are using blkback.
>> 
>> Right, sorry for the confusion.
>> 
>> > Also, running the test only for 10s and 3 repetitions seems too low, I
>> > would probably try to run the tests for a longer time and do more
>> > repetitions, and include the standard deviation also.
>> >
>> > Could you try to revert the patches independently to see if it's a
>> > specific commit that introduces the regression?
>> 
>> I did additional test runs. Now I'm comparing 3 kernels:
>> 1) Unmodified v3.15-rc5-157-g60b5f90 - green color on chart
>> 
>> 2) v3.15-rc5-157-g60b5f90 with bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>> and 427bfe07e6744c058ce6fc4aa187cda96b635539 reverted (so only
>> fbe363c476afe8ec992d3baf682670a4bd1b6ce6 "xen-blkfront: revoke foreign
>> access for grants not mapped by the backend" left) - blue color on chart
>> 
>> 3) v3.15-rc5-157-g60b5f90 with all
>> (bfe11d6de1c416cea4f3f0f35f864162063ce3fa,
>> 427bfe07e6744c058ce6fc4aa187cda96b635539,
>> fbe363c476afe8ec992d3baf682670a4bd1b6ce6) patches reverted - red color
>> on chart.
>> 
>> I test on top of striped LVM on 2 FusionIO drives, I do 3 repetitions for
>> 30 seconds each.
>> 
>> The result is here:
>> http://hadoop.ru/pubfiles/bug1096909/fusion/315_nopgrants_20140612.pn
>> g
>> 
>> It is consistent with what I've measured with ramdrives and tmpfs files:
>> 
>> 1) fbe363c476afe8ec992d3baf682670a4bd1b6ce6 "xen-blkfront: revoke
>> foreign access for grants not mapped by the backend" brings us the
>> regression. Bigger block size is - bigger the difference but the regression is
>> observed with all block sizes > 8k.
>> 
>> 2) bfe11d6de1c416cea4f3f0f35f864162063ce3fa "xen-blkfront: restore the
>> non-persistent data path" brings us performance improvement but with
>> conjunction with fbe363c476afe8ec992d3baf682670a4bd1b6ce6 it is still
>> worse than the kernel without both patches.
>> 
>> My Dom0 is Fedora's 3.7.9-205.fc18.x86_64. I can test on newer blkback,
>> however I'm not aware of any way to disable persistent grants there (there is
>> no regression when they're used).
>> 
>> >
>> > Thanks, Roger.
>> 
>> Thanks,
>> 
>> --
>>   Vitaly

-- 
  Vitaly
