Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaHZGQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:16:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10224 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbaHZGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:16:38 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-42-53fc2643fa18
Message-id: <53FC263B.9010709@samsung.com>
Date: Tue, 26 Aug 2014 08:16:27 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 03/15] drm/exynos/ipp: move file reference from memory to
 command node
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-4-git-send-email-a.hajda@samsung.com>
 <53FBF71B.7070107@samsung.com> <53FBF818.70407@samsung.com>
In-reply-to: <53FBF818.70407@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xK7rOan+CDe59NbK48vU9m8Wk+xNY
	LF7cu8hicbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5cHjc7z7O5NG3ZRWjx+dNcgHMUVw2
	Kak5mWWpRfp2CVwZL89tZCxol6j41rmLrYHxlXAXIyeHhICJxN+Fe9ggbDGJC/fWA9lcHEIC
	SxklZv29wQ7hfGKUePF4LiNIFa+AlkTH1odgHSwCqhI3J98Ci7MJaEr83XwTLC4qECbx7NdB
	Joh6QYkfk++xgNgiAr4SW/6/ZgQZyiywgEni24MOsCJhgRiJW3euskBs280o8eN6K2sXIwcH
	J9DUFytKQUxmAT2J+xe1QMqZBeQlNq95yzyBUWAWkhWzEKpmIalawMi8ilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMktL/uYFx6zOoQowAHoxIP74O038FCrIllxZW5hxglOJiVRHgZHgKF
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MNor3Zzy1W5p+uGv2/56+H9gkdE7WefkP2FZm/uj6M/i
	sx+un5j55F54ifdZr8R9x4NldgSrT5Cc/HMyx3KdB6aeQmKn5h/8tp5/i2Ow+sclM6ZLinez
	a0efFt8sYXixaK/YHtU8Q9uHiToVD+/7/96yJ23jjtJ7AoslqtVkuW/eafS3rIk7vFeJpTgj
	0VCLuag4EQBRgnh8SwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonyoung,

Thanks for review.

On 08/26/2014 04:59 AM, Joonyoung Shim wrote:
> On 08/26/2014 11:55 AM, Joonyoung Shim wrote:
>> Hi Andrzej,
>>
>> On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
>>> Command node should contain file reference to distinguish commands
>>> created by different processes.
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 ++---
>>>  drivers/gpu/drm/exynos/exynos_drm_ipp.h | 2 ++
>>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>>> index 9770966..bbe9968 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>>> @@ -75,7 +75,6 @@ struct drm_exynos_ipp_mem_node {
>>>  	u32	prop_id;
>>>  	u32	buf_id;
>>>  	struct drm_exynos_ipp_buf_info	buf_info;
>>> -	struct drm_file		*filp;
>>>  };
>>>  
>>>  /*
>>> @@ -448,6 +447,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
>>>  	c_node->dev = dev;
>>>  	c_node->property = *property;
>>>  	c_node->state = IPP_STATE_IDLE;
>>> +	c_node->filp = file;
>>>  
>>>  	c_node->start_work = ipp_create_cmd_work();
>>>  	if (IS_ERR(c_node->start_work)) {
>>> @@ -645,7 +645,6 @@ static struct drm_exynos_ipp_mem_node
>>>  		}
>>>  	}
>>>  
>>> -	m_node->filp = file;
>>>  	mutex_lock(&c_node->mem_lock);
>>>  	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
>>>  	mutex_unlock(&c_node->mem_lock);
>>> @@ -677,7 +676,7 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
>> Then, could you remove file argument from exynos_drm_ipp_queue_buf() and
>> ipp_get_event()?
> sorry, i mean ipp_put_mem_node() instead of exynos_drm_ipp_queue_buf().

I guess you mean ipp_get_mem_node() and ipp_get_event().
You are right, it should be removed. Additionally file check should be added
to exynos_drm_ipp_queue_buf.

Regards
Andrzej

>
>>>  		unsigned long handle = m_node->buf_info.handles[i];
>>>  		if (handle)
>>>  			exynos_drm_gem_put_dma_addr(drm_dev, handle,
>>> -							m_node->filp);
>>> +							c_node->filp);
>>>  	}
>>>  
>>>  	/* delete list in queue */
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
>>> index 6f48d62..0311035 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
>>> @@ -62,6 +62,7 @@ struct drm_exynos_ipp_cmd_work {
>>>   * @stop_work: stop command work structure.
>>>   * @event_work: event work structure.
>>>   * @state: state of command node.
>>> + * @filp: associated file pointer.
>>>   */
>>>  struct drm_exynos_ipp_cmd_node {
>>>  	struct device		*dev;
>>> @@ -78,6 +79,7 @@ struct drm_exynos_ipp_cmd_node {
>>>  	struct drm_exynos_ipp_cmd_work *stop_work;
>>>  	struct drm_exynos_ipp_event_work *event_work;
>>>  	enum drm_exynos_ipp_state	state;
>>> +	struct drm_file	*filp;
>>>  };
>>>  
>>>  /*
>>>
>>
>

