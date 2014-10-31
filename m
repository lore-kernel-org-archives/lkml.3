Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbaJaOWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:22:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58384 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaJaOWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:22:36 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-39-54539b28f2a7
Message-id: <54539AF3.6060302@samsung.com>
Date: Fri, 31 Oct 2014 15:21:39 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Organization: Samsung Poland R&D Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.1.2
MIME-version: 1.0
To: Paul Moore <pmoore@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk,
        linux-security-module@vger.kernel.org,
        Karol Lewandowski <lmctlx@gmail.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <54520A21.20404@samsung.com> <20141030144709.GA19721@kroah.com>
 <545297CC.6020306@samsung.com> <5113482.YUK8i6Rueb@sifl>
In-reply-to: <5113482.YUK8i6Rueb@sifl>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xq7oas4NDDLac1bO4svUIk8XfScfY
	LW6sWMBk0fT3FYtF9zUWi3mtR1ksmhevZ7M4+rvAYvecxSwWZ37rWmz+3sFmcXnXHDaLDz2P
	2CwWHnjEbvHt0y9Gi8/XfrFbtK+4zWix8vd2Notfy48yOgh7/P41idHj7/PrLB43ZnWweuyc
	dZfdY/3u5ewei/e8ZPLYtKqTzePOtT1sHvvnrmH3WPHrCLvH+31X2TzOLACyPm+S89i+ezlL
	AF8Ul01Kak5mWWqRvl0CV8afzxuYCg4JVrQvfsjewPibt4uRg0NCwERi277ULkZOIFNM4sK9
	9WxdjFwcQgJLGSWa7y1gh3A+MUps/nuYBaSKV0BLYu+CJcwgNouAqsTFdw1gcTYBI4lvhzaA
	xfkF1CXebXvKBGKLCoRItF5pYYPoFZT4MfkeWL2IQKjEsx3bWEEWMAucZZF4tQ/E4eQQFjCW
	mHTiDSPE5jZGiZPHd4AlOAXUJG4232UGOZsZaMOUKbkgYWYBeYnNa94yT2AUnIVkxyyEqllI
	qhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECInkLzsYFx+zOsQowMGoxMO7QjI4RIg1
	say4MvcQowQHs5II748OoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGkvrUlWfO2HlmibufXKgq
	a6uxOo//aFNChhhDzpGtZ6WcjJzyfkTEvq4yZwpw/76oqb1MaXHbQibn+V9Zn5zK9D1mel3h
	285X3efEngffbLK8nTV34rbn4l0ivyvctHwuTtTYeXX2bZXC5f68ms6XI244n9hz3PqzyeYd
	BnF7DC5tuNSj+ueFEktxRqKhFnNRcSIAyEVJyMICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-31 00:39, Paul Moore wrote:
> On Thursday, October 30, 2014 08:55:56 PM Karol Lewandowski wrote:
>> On 2014-10-30 15:47, Greg Kroah-Hartman wrote:
>>> Other than that, I don't know exactly what your patches do, or why they
>>> are needed, care to go into details?
>>
>> Patches in question were supposed to add few hooks for kdbus-specific
>> operations that doesn't seem to have compatible semantics with hooks
>> currently available in LSM.
>>
>> kdbus' bus introduces quite a few new concepts that we wanted to be able
>> to limit based on MAC label/context, eg.
>>
>>  - check flags at HELO stage (say disallow fd passing),
>>
>>  - restrict ability to acquire name to certain subjects (for system bus),
>>
>>  - disallow creation of new buses,
>>
>>  - limit scope of broadcasts,
>>
>>  - etc.
>>
>> Please take a look at hook list - I think most of names are
>> self-explanatory:
>>
>>  
>> https://github.com/lmctl/linux/blob/a9fe4c33b6e5ab25a243e0590df406aabb6add1
>> 2/include/linux/security.h#L1874
>>
>> kdbus modifications were pretty light - with most visible change being
>> addition of opaque security pointer to kdbus_bus and similar structs.
> 
> [NOTE: we really should add the LSM list to this discussion and future 
> patchset postings.]
> 
> Also, to be completely honest, I don't think we ever really arrived at any 
> final conclusion about those LSM/kdbus hooks either.  At least I don't think I 
> ever really satisfied myself that what we had was the "right" solution.

Agreed, "hooks" are far from being complete.  I think that patches
were and still are - a starting point for discussion, not "a solution"
itself.

Timing wasn't good either - since our last discussion (Apr/May 2014)
kdbus policy engine has been completely rewritten and few core concepts
changed too.

> We both got busy and kinda drifted away from this effort.  Karol, did you do 
> any further work on the hooks?

I didn't.  I was waiting for the peace of change in kdbus to slow
down a bit and, honestly, wasn't expecting submission in few next
months...

I'll do my best to post RFC patchset today or tomorrow.

Thanks
-- 
Karol Lewandowski, Samsung R&D Institute Poland
