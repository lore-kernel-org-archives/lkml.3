Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3EaKbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:31:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33157 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3EaKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:31:38 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-d3-51a87c07d64f
Message-id: <51A87C05.9020703@samsung.com>
Date: Fri, 31 May 2013 12:31:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC v2] media: OF: add sync-on-green endpoint property
References: <1368710287-8741-1-git-send-email-prabhakar.csengg@gmail.com>
 <CA+V-a8tMQnjh=8qaRoNhwkdrcoTCK2zofTkCOd79hAMoz5qK2A@mail.gmail.com>
 <51A0C6A8.5090302@gmail.com> <44193648.yaA827Trlv@avalon>
In-reply-to: <44193648.yaA827Trlv@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4ZV32mhWBBnu/m1icu9XAanFg9kNW
	i/cb5zFZvDqzkc1iyc9dTBZnm96wW3ROXMJusbBtCYvF5V1z2Cx6Nmxltdhz9DC7xcv7K5gt
	Dq84wGSx7uV0Fosz+1eyOfB7LPh8hd1jyu+NrB47Z91l9/jwMc5jdsdMVo/DXxeyeLxaDWTN
	mdbE4nF+xkJGj/f7rrJ59G1Zxejx86WOx+dNcgG8UVw2Kak5mWWpRfp2CVwZc161shYsFq/Y
	2tXN3MD4T6iLkZNDQsBE4uDDB6wQtpjEhXvr2boYuTiEBJYySrQc6WOCcD4BOYu2s4FU8Qpo
	SaxZfpYRxGYRUJXYdmsyO4jNJmAo0Xu0DywuKhAgsXjJOXaIekGJH5PvsYDYIgIWEr2LpjOC
	DGUWOMgisWfrTbCEsICXxP8Lc1khtp1hlOheuIEZJMEpoCnxclkH2H3MAjoS+1unsUHY8hKb
	17xlnsAoMAvJkllIymYhKVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQOv+xgXHzM
	6hCjAAejEg9vZtLyQCHWxLLiytxDjBIczEoivD15KwKFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MNZsW3n0XIazwmS9DTvO1nu0mixsvfPzpvtJt4jjkuu9DzSvv8naeva3kJrhXYMN8ZvetM/y
	rV4gY8cj9X3NpojP/mVdf278K3UV/+yWnt8qmf9m+kIez5Ca9CNtHeJ9dzv6NvMkOs5k5/Xu
	Nr2t/T/YSY3txGePqCCmBzfehaQ+zzrZKBN3RYmlOCPRUIu5qDgRAIYkdMOhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 05:21 AM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Saturday 25 May 2013 16:11:52 Sylwester Nawrocki wrote:
>> On 05/25/2013 11:17 AM, Prabhakar Lad wrote:
[...]
>>>>>  And for synchronisation method on the analog part we could perhaps
>>>>>  define 'component-sync' or similar property that would enumerate all
>>>>>  possible synchronisation methods. We might as well use separate
>>>>>  boolean properties, but I'm a bit concerned about the increasing
>>>>>  number of properties that need to be parsed for each parallel video
>>>>>  bus "endpoint".
>>>
>>> I am not clear on it can please elaborate more on this.
>>
>> I thought about two possible options:
>>
>> 1. single property 'component-sync' or 'video-sync' that would have values:
>>
>> #define VIDEO_SEPARATE_SYNC	0x01
>> #define VIDEO_COMPOSITE_SYNC	0x02
>> #define VIDEO_SYNC_ON_COMPOSITE	0x04
>> #define VIDEO_SYNC_ON_GREEN	0x08
>> #define VIDEO_SYNC_ON_LUMINANCE	0x10
>>
>> And we could put these definitions into a separate header, e.g.
>> <dt-bindings/video-interfaces.h>
>>
>> Then in a device tree source file one could have, e.g.
>>
>> video-sync = <VIDEO_SYNC_ON_GREEN>;
>>
>>
>> 2. Separate boolean property for each video sync type, e.g.
>>
>> 	"video-composite-sync"
>> 	"video-sync-on-composite"
>> 	"video-sync-on-green"
>> 	"video-sync-on-luminance"
>>
>> Separate sync, with separate VSYNC, HSYNC lines, would be the default, when
>> none of the above is specified and 'vsync-active', 'hsync-active' properties
>> are present.
> 
> I prefer 1. over 2.
> 
>> However, I suppose the better would be to deduce the video synchronisation
>> method from the sync signal polarity flags. Then, for instance, when an
>> endpoint node contains "composite-sync-active" property the parser would
>> determine the "composite sync" synchronisation type is used.
>>
>> Thus it might make sense to have only following integer properties (added
>> as needed):
>>
>> composite-sync-active
>> sync-on-green-active
>> sync-on-comp-active
>> sync-on-luma-active
>>
>> This would allow to specify polarity of each signal and at the same time
>> the parsing code could derive synchronisation type. A new field could be
>> added to struct v4l2_of_parallel_bus, e.g. sync_type and it would be filled
>> within v4l2_of_parse_endpoint().
>>
>> What do you think ?
> 
> My gut feeling is that we should have separate properties for the video sync 
> type and the synchronization signals polarities. We could have a chip that 
> supports sync-on-green on the analog (input) side and outputs separate hsync 
> and vsync signals only on the digital (output) side. There would be no sync-
> on-green polarity in that case.

Yes, agreed. I've had some doubts that using single DT property for defining
really 2 distinct H/W properties like this might not be flexible enough.
The option 1. seems most correct then.

Regards,
Sylwester
