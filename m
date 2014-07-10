Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaGJH5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:57:03 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:42913 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGJH5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:57:01 -0400
Date: Thu, 10 Jul 2014 11:56:15 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, matwey.kornilov@gmail.com
Subject: Re: [PATCHv3 2/2] Add force_epp module option for parport_pc.
In-Reply-To: <20140709212910.GB26562@kroah.com>
Message-ID: <alpine.LRH.2.00.1407101045510.25305@lnfm1.sai.msu.ru>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru> <20140709212910.GB26562@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jul 2014, Greg KH wrote:

> On Mon, Jul 07, 2014 at 11:01:51AM +0400, Matwey V. Kornilov wrote:
>>> From cf37d0cc4d51da5c0b368e1f5ab05082c041d1e1 Mon Sep 17 00:00:00 2001
>> From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
>> Date: Wed, 25 Jun 2014 01:08:45 +0400
>> Subject: [PATCHv3 2/2] Add force_epp module option for parport_pc.
>>
>> The detection of Intel EPP bug is known to produce much false positives.
>> The new option is introduced to force enable EPP in spite of the test result.

Hi,

First of all, maybe I missed something fundamental, or did something 
wrong, but I can't understand how is it going to break working systems? We 
have current behaviour B0, and introduce an option switches between B0 
(which is default value) and alternative behaviour B1. So, until you go to 
/etc/modprobe.d to override defaults or modprobe with specific option the 
current behaviour B0 is active. Am I not right here?

> module parameters are horrid, how is someone supposed to know to use
> this?

I usually do `modinfo' to list existing options. Do I understand right 
that description has to be added into Documentations also?

> Why can't we "fix" the detection logic?

Initial check had been introduced in 1999 [1], however I am failed to find 
any proves, because davej/history.git is missed. Initial committer is 
unknown. The check fixes issue with the affected hardware (A) and 
introduces new one with false-positive (F) hardware.

Now, there are no evidences of what hardware is affected (it seems to be 
quite aged), and no owners of this hardware are known. So, If I had fixed 
the detection logic (in one or another way), I would have not been able to 
check it.

What I am trying to do here (as it is described in 0/2) is to allow people 
with false-positive hardware somehow operate with it.

> You just now broke systems that were working by forcing them to now set a module option
> where previously they didn't

See above.

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=630593#79

