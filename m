Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbaJaLQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:16:42 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47928 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbaJaLQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:16:39 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-c4-54536f941be7
Message-id: <54536F5E.7030604@samsung.com>
Date: Fri, 31 Oct 2014 12:15:42 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Organization: Samsung Poland R&D Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.1.2
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <54520A21.20404@samsung.com> <54521697.1030900@samsung.com>
 <20141030144709.GA19721@kroah.com> <545297CC.6020306@samsung.com>
 <20141030202434.GA17410@kroah.com>
In-reply-to: <20141030202434.GA17410@kroah.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t/xa7pT8oNDDK5uY7a4svUIk8XfScfY
	LW6sWMBk0fT3FYtF9zUWi3mtR1ksmhevZ7M4+rvAYvecxSwWZ37rWmz+3sFmcXnXHDaLDz2P
	2Cy+ffrFaPH52i92i/YVtxktVv7ezmbxa/lRRgchj9+/JjF6/H1+ncXjxqwOVo+ds+6ye6zf
	vZzdY/Gel0wem1Z1snncubaHzWP/3DXsHit+HWH3eL/vKpvHmQVA1udNch7bdy9nCeCL4rJJ
	Sc3JLEst0rdL4Mr4+XYVe8E0qYrGRSeYGhhbRbsYOTkkBEwk3sz/wwZhi0lcuLceyObiEBJY
	yihxceYiRgjnE6PErUVvmUCqeAW0JBZM3QZmswioSjRc7GQFsdkEjCS+HdrADGLzC6hLvNv2
	FKxGVCBEovVKCxtEr6DEj8n3WEBsEQFjif6zs9hBFjALHGeRuD77LFizMFBi0ok3UJs3MEp0
	P+sH6+YU0Jc40bUVqJsDqENdYsqUXJAws4C8xOY1b5knMArOQrJjFkLVLCRVCxiZVzGKppYm
	FxQnpeca6hUn5haX5qXrJefnbmKERPCXHYyLj1kdYhTgYFTi4V0hGRwixJpYVlyZe4hRgoNZ
	SYT3XzpQiDclsbIqtSg/vqg0J7X4ECMTB6dUAyOH4+ZlYRO5cjewxv3I3F545OA3oS3Wygk7
	11fnTGRW/PQs66TS7s17FloFnROQzC5P2tv3sivNOa06oymq7Gv8Fqu0ZovaL9cXSJ4wdFoi
	uPKFkIpPpm3s7py0qy+m7mFK+/xxV6zXqrMXLjhILJyRuMtV9fUdhk75o1tdb5ze42z2XW3u
	82VKLMUZiYZazEXFiQAnd+t0vgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-30 21:24, Greg Kroah-Hartman wrote:
> On Thu, Oct 30, 2014 at 08:55:56PM +0100, Karol Lewandowski wrote:
>> On 2014-10-30 15:47, Greg Kroah-Hartman wrote:
>>> On Thu, Oct 30, 2014 at 11:44:39AM +0100, Karol Lewandowski wrote:
>>>> [ Sorry for breaking thread and resend - gmane rejected my original message
>>>>   due to too long list of recipients... ]
>>>>
>>>> On 2014-10-30 00:40, Greg Kroah-Hartman wrote:
>>>>
>>>>> There is a 1815 line documentation file in this series, so we aren't
>>>>> trying to not provide this type of information here at all.  But yes,
>>>>> more background, about why this can't be done in userspace (zero copy,
>>>>> less context switches, proper credential passing, timestamping, availble
>>>>> at early-boot, LSM hooks for security models to tie into
>>>>
>>>> While you're at it... I did some work on proof-of-concept LSM patches for
>>>> kdbus some time ago, see [1][2].  Currently, these are completely of date.
>>>>
>>>>  [1] https://github.com/lmctl/linux/commits/kdbus-lsm-v4.for-systemd-v212
>>>>  [2] https://github.com/lmctl/kdbus/commit/aa0885489d19be92fa41c6f0a71df28763228a40
>>>>
>>>> May I ask if you guys have your own plan for LSM or maybe it would be
>>>> worth to resurrect [1]?
>>>
>>> The core calls are already mediated by LSM today, right?  We don't want
>>> anyone to be parsing the data stream through an LSM, that idea got
>>> rejected a long time ago as something that is really not a good idea.
>>
>> Parsing data is out of question, of course, but this is not what we were
>> proposing.
> 
> Glad to hear it :)
> 
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
> 
> Nice list.
> 
>> Please take a look at hook list - I think most of names are self-explanatory:
>>
>>   https://github.com/lmctl/linux/blob/a9fe4c33b6e5ab25a243e0590df406aabb6add12/include/linux/security.h#L1874
>>
>> kdbus modifications were pretty light - with most visible change being
>> addition of opaque security pointer to kdbus_bus and similar structs.
> 
> That looks very reasonable, care to make it up into a patch I can add to
> the end of this series so it's easy to review and possibly submit as
> part of it?

I'll do my best to prepare something suitable for review, but I'm
not sure it can/should be part of next patch set.

As Paul wrote - discussion about hooks hasn't really ended up with
satisfactory conclusion but just faded away.  kdbus own policy engine
has been  rewritten since I last touched it so I'm not sure what part
are still applicable.

(Unfortunately, I'll be traveling from monday and likely to be offline
for a week or two...)

Thanks
-- 
Karol Lewandowski, Samsung R&D Institute Poland
