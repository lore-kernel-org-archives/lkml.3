Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaGNHji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:39:38 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:42599 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752490AbaGNHjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:39:32 -0400
Message-ID: <53C3876F.2080103@daenzer.net>
Date: Mon, 14 Jul 2014 16:31:59 +0900
From: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
CC: Alex Deucher <alexdeucher@gmail.com>, Oded Gabbay <oded.gabbay@gmail.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com> <20140711160516.GC1870@gmail.com>	<53C00E6E.4040908@amd.com> <CADnq5_NkXJuaeMWv8HogykiH8ida17U90gO0Ec7DMRxMcLbrkA@mail.gmail.com> <53C0F921.2030909@amd.com>
In-Reply-To: <53C0F921.2030909@amd.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.07.2014 18:00, Christian König wrote:
> Am 11.07.2014 18:22, schrieb Alex Deucher:
>> On Fri, Jul 11, 2014 at 12:18 PM, Christian König
>> <christian.koenig@amd.com> wrote:
>>> Am 11.07.2014 18:05, schrieb Jerome Glisse:
>>>
>>>> On Fri, Jul 11, 2014 at 12:50:02AM +0300, Oded Gabbay wrote:
>>>>> To support HSA on KV, we need to limit the number of vmids and pipes
>>>>> that are available for radeon's use with KV.
>>>>>
>>>>> This patch reserves VMIDs 8-15 for KFD (so radeon can only use VMIDs
>>>>> 0-7) and also makes radeon thinks that KV has only a single MEC with a
>>>>> single
>>>>> pipe in it
>>>>>
>>>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>>> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
>>>
>>> At least fro the VMIDs on demand allocation should be trivial to
>>> implement,
>>> so I would rather prefer this instead of a fixed assignment.
>> IIRC, the way the CP hw scheduler works you have to give it a range of
>> vmids and it assigns them dynamically as queues are mapped so
>> effectively they are potentially in use once the CP scheduler is set
>> up.
> 
> That's not what I meant. Changing it completely on the fly is nice to
> have, but we should at least make it configurable as a module parameter.
> 
> And even if we hardcode it we should use a define for it somewhere
> instead of hardcoding 8 VMIDs on the KGD side and 8 VMIDs on KFD side
> without any relation to each other.

Seconded, and there should be more explanation and rationale for the way
things are set up in the code or at least in the commit log.


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
