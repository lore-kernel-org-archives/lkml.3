Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3LPLDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:03:07 -0500
Received: from canardo.mork.no ([148.122.252.1]:59265 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab3LPLDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:03:05 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, jinchoi@broadcom.com,
        Paul Bolle <pebolle@tiscali.nl>,
        ziegler@email.mathematik.uni-freiburg.de,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        jbarnes@virtuousgeek.org
Subject: Re: Regression with suspend resume 5a87182aa21d6d5d306840feab9321818dd3e2a3
Organization: m
References: <52A448F2.4010208@redhat.com>
	<CAKohpomO+0q7bFWTnFRgqoRuU2WryfPpFv0WLOCKtHBrLzLRqw@mail.gmail.com>
Date: Mon, 16 Dec 2013 12:02:23 +0100
In-Reply-To: <CAKohpomO+0q7bFWTnFRgqoRuU2WryfPpFv0WLOCKtHBrLzLRqw@mail.gmail.com>
	(Viresh Kumar's message of "Mon, 16 Dec 2013 16:10:55 +0530")
Message-ID: <87iouprrcw.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:
> On 8 December 2013 15:54, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>> I'm testing recent 3.13-rc kernel - and I've notice my Lenovo T61 is not
>> able to resume.  After bisect I've found commit:
>>
>> 5a87182aa21d6d5d306840feab9321818dd3e2a3
>
> That's my patch, sorry for all the trouble.. Just came back after vacations
> and multiple threads are there with this patch as culprit..
>
> I just tested this patch again on Rafael's linux-next branch and suspend/resume
> and Hibernation are working fine for me on my Thinkpad T420. I don't see any
> issues at all..
>
> scaling_governor: ondemand
> scaling_driver: acpi-cpufreq
>
>> When I just revert this commit with 374b105797c3d4f29c685f3be535c35f5689b30e
>> (3.13-rc3)   suspend/resume works again.
>> (I'm using  ondemand CPU governor)
>
>> Here is bisect log:
>
>> # bad: [2167e2399dc5e69c62db56d933e9c8cbe107620a] cpufreq: fix garbage
>> kobjects on errors during suspend/resume
>> git bisect bad 2167e2399dc5e69c62db56d933e9c8cbe107620a
>
> I don't read bisect logs well but doesn't you log say that the culprit is
> 2167e2399dc5e69c62db56d933e9c8cbe107620a instead?
>
> I am trying with this patch now, but will take some time for results to be out.

It's both patches in combination.  Interesting case, really :-)



Bjørn
