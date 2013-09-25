Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3IYOxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:53:25 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:52159 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3IYOxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:53:24 -0400
MIME-Version: 1.0
In-Reply-To: <5242C960.7050506@hurleysoftware.com>
References: <20130913005133.GA32479@localhost>
	<20130913010936.GA1291@localhost>
	<5238767D.1080606@hurleysoftware.com>
	<20130917232214.GA11390@localhost>
	<5238F252.5070905@hurleysoftware.com>
	<CAF1ivSbYg296oHhO0_UXwkos8Ui_1C93pUnXPzow4qLWyAa2kg@mail.gmail.com>
	<5242C960.7050506@hurleysoftware.com>
Date: Wed, 25 Sep 2013 22:53:22 +0800
Message-ID: <CAF1ivSaAcZfwAmdUhH1SZeaRLokNBVA4ScxTWeifHVWXiX_e-Q@mail.gmail.com>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers into n_tty_data"
From: Lin Ming <minggr@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 7:30 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 09/25/2013 05:04 AM, Lin Ming wrote:
>>
>> On Wed, Sep 18, 2013 at 8:22 AM, Peter Hurley <peter@hurleysoftware.com>
>> wrote:
>> [snip]
>>>
>>>
>>> Looking over vmalloc.c, the critical section footprint of the
>>> vmap_area_lock
>>> could definitely be reduced (even nearly eliminated), but that's a
>>> project
>>> for
>>> another day :)
>>
>>
>> Hi Peter,
>>
>> I also looked over vmallo.c, but didn't find obvious way to reduce the
>> critical section footprint.
>> Could you share some hints how to do this?
>
>
> vmap_area_list is an RCU list.
> get_vmalloc_info() doesn't need to take the vmap_area_lock at all.
> Look at __purge_vmap_area_lazy() for a howto.

Looking at it now ...

Thanks,
Lin Ming

>
> Regards,
> Peter Hurley
>
