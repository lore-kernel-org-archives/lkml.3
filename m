Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaGJRdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:33:23 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61977 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaGJRdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140710170954.GB23544@kroah.com>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru>
 <20140709212910.GB26562@kroah.com> <alpine.LRH.2.00.1407101045510.25305@lnfm1.sai.msu.ru>
 <20140710170954.GB23544@kroah.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Thu, 10 Jul 2014 21:32:59 +0400
X-Google-Sender-Auth: DT77OExGshJyB_NVAjc_tV6ZXXw
Message-ID: <CAJs94Eao-ujjZevjptf5hhmkS742HdUVafP4avHR3gx0WzuSTw@mail.gmail.com>
Subject: Re: [PATCHv3 2/2] Add force_epp module option for parport_pc.
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-parport <linux-parport@lists.infradead.org>,
        Heiko Andreas Sommer <hsommer@eso.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-10 21:09 GMT+04:00 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, Jul 10, 2014 at 11:56:15AM +0400, Matwey V. Kornilov wrote:
>>
>>
>> On Wed, 9 Jul 2014, Greg KH wrote:
>>
>> >On Mon, Jul 07, 2014 at 11:01:51AM +0400, Matwey V. Kornilov wrote:
>> >>>From cf37d0cc4d51da5c0b368e1f5ab05082c041d1e1 Mon Sep 17 00:00:00 2001
>> >>From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
>> >>Date: Wed, 25 Jun 2014 01:08:45 +0400
>> >>Subject: [PATCHv3 2/2] Add force_epp module option for parport_pc.
>> >>
>> >>The detection of Intel EPP bug is known to produce much false positives.
>> >>The new option is introduced to force enable EPP in spite of the test result.
>>
>> Hi,
>>
>> First of all, maybe I missed something fundamental, or did something wrong,
>> but I can't understand how is it going to break working systems?
>
> I thought you disabled the quirk test and now rely on the module option
> instead.  That would require a machine that was happily relying on the
> quirk test to now be forced to add a module option, right?

No, this would not...

> Or did I read the patch incorrectly?

Maybe I've implemented something incorrectly? I think I suggested
exactly inverse thing: the check is disabled only when the option is
touched by user:

!force_epp && intel_bug_present(pb) <=> intel_bug_present(pb) (given
that force_epp is false)

> Why not implement Alan's suggestion?

Why not, if you are fine with it. Are you sure that PPro was turning point?
