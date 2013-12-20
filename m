Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049Ab3LTOcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:32:46 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44085 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161024Ab3LTOcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:32:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAA6-i6pDqDemeQ+s4EorOx39qmNAtAfVYfg0Z2wtTEu-S7mY=A@mail.gmail.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
	<abff42910c131a9c94a7518de59b283ee0a2dcd1.1387193771.git.vdavydov@parallels.com>
	<20131220092659.0ed23cf5@redhat.com>
	<CAA6-i6pDqDemeQ+s4EorOx39qmNAtAfVYfg0Z2wtTEu-S7mY=A@mail.gmail.com>
Date: Fri, 20 Dec 2013 18:32:41 +0400
Message-ID: <CAA6-i6rqCm44yJjf0dy=L+rYGEH=WUoNzX4+qh5poGgSsA=W-Q@mail.gmail.com>
Subject: Re: [PATCH v14 16/18] vmpressure: in-kernel notifications
From: Glauber Costa <glommer@gmail.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, dchinner@redhat.com,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>,
        John Stultz <john.stultz@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One correction:

>>  int vmpressure_register_kernel_event(struct cgroup_subsys_state *css,
>> -                                     void (*fn)(void))
>> +                                    void (*fn)(void *data, int level), void *data)
>>  {
>> -       struct vmpressure *vmpr = css_to_vmpressure(css);
>> +       struct vmpressure *vmpr;
>>         struct vmpressure_event *ev;
>>
>> +       vmpr = css ? css_to_vmpressure(css) : memcg_to_vmpressure(NULL);
>> +

This looks like it could be improved. Better not to have that memcg
specific thing
here.

Other than that it makes sense.
