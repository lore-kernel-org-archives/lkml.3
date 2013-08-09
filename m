Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968179Ab3HIQmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:42:08 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:27680 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968090Ab3HIQmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:42:02 -0400
X-AuditID: cbfec37b-b7f306d0000047de-92-52051bd87015
From: Shuah Khan <shuah.kh@samsung.com>
To: "joro@8bytes.org" <joro@8bytes.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Varun.Sethi@freescale.com" <Varun.Sethi@freescale.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>, "joe@perches.com" <joe@perches.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "andreas.herrmann@calxeda.com" <andreas.herrmann@calxeda.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] iommu: Add event tracing feature to iommu
Thread-topic: [PATCH v2] iommu: Add event tracing feature to iommu
Thread-index: AQHOjTUnsrYFQaOJcE+QqVy2rH05tQ==
Date: Fri, 09 Aug 2013 16:41:58 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61761EFF@sisaex02sj>
References: <1375196229-2784-1-git-send-email-shuah.kh@samsung.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9hX90b0qxBBpMnS1n0Hi+y+Pa/h81i
	8ZEYi5mvu5ksFuy3tph9/zGLRefsDewWl3fNYbO4dGABk8Xv1T+YLfZ1PGCy+PrTwWL/FS+L
	mbfWsFi8/HiCxYHf48nBeUwea+atYfT49nUSi8eCz1fYPf4d7mfy2DnrLrtHy75b7B6Tbyxn
	9Lhxt5nN48uqa8we7/ddZfP4vEnO49OnfWwBvFFcNimpOZllqUX6dglcGfcP3mMs+CReMeNu
	N2sD4zLhLkZODgkBE4nZK3YxQthiEhfurWfrYuTiEBJYxijR8WUHE4TTyyRx88pPqMx8Rol1
	uzcwgbSwCahLfH69gx3EFgGyr727DFbELNDCJtHWvwuoiINDWMBRYuYlB4gaJ4k5b+cyQ9h6
	Eq97IeawCKhKfGv+wAZi8wrYS2x49JEZpFVIwFli80VLkDAj0HXfT60BK2cWEJdobr3JAnG1
	gMSSPeeZIWxRiZeP/7GCtEoIKEpsX20FUa4lsX7ncahWbYkn7y6wQmwSlPgx+R7LBEaxWUim
	zkLSMgtJyywkLQsYWVYxipUWJxcUJ6WnVhjpFSfmFpfmpesl5+duYoQkieodjHe/2hxiFOBg
	VOLhnfCLJUiINbGsuDL3EKMEB7OSCO9rLtYgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzuXJqT
	zDn3uyzZuPXZwreFfdHcz7wDlf/ctv/9+hlvW5ZQpedSVkM5rVZVrieth16HuETf+Lvm282I
	NaVTfTuXzm+fdpbVUeRL4qm721SyXmY9sG7ZefCh5Jd1y37vfGHb3uk5//nM1zy5x1ef4KpM
	7zi2QOtQVtrG3xP0S79051YveFDM9/uHEktxRqKhFnNRcSIA3iZLHvACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 08:57 AM, Shuah Khan wrote:
> Add tracing feature to iommu to report various iommu events. Classes
> iommu_group, iommu_device, iommu_map_unmap, and iommu_amd_event are defined.
>
> iommu_group class events can be enabled to trigger when devices get added
> to and removed from an iommu group. Trace information includes iommu group
> id and device name.
>
> iommu:add_device_to_group
> iommu:remove_device_from_group
>
> iommu_device class events can be enabled to trigger when devices are attached
> to and detached from a domain. Trace information includes device name.
>
> iommu:attach_device_to_domain
> iommu:detach_device_from_domain
>
> iommu_map_unmap class events can be enabled to trigger when iommu map and
> unmap iommu ops. Trace information includes iova, physical address (map event
> only), and size.
>
> iommu:unmap
> iommu:map
>
> iommu_amd_event class can be enabled to trigger when AMD IOMMU driver finds
> events when it polls the IOMMU Event Log. Trace information includes the
> event string derived from the event type in human friendly form, event type,
> id of the domain the device is placed in, device (bus number, slot number,
> and function number), address associated with the event, and flags.
>
> iommu:amd_event
>
> Testing:
> The following is trace is generated when intel-iommu driver adds devices to
> to iommu groups during boot-time during its initialization:
>
>         swapper/0-1     [003] ....     1.854793: add_device_to_group: IOMMU: groupID=0 device=0000:00:00.0
>         swapper/0-1     [003] ....     1.854797: add_device_to_group: IOMMU: groupID=1 device=0000:00:02.0
>
> Added trace calls to iommu_prepare_identity_map() for testing some of the
> conditions that are hard to trigger. Here is the trace from the testing:
>         swapper/0-1     [003] ....     1.854099: amd_event: IOMMU:ILLEGAL_DEV_TABLE_ENTRY 0x01 00:00.0 d=0x0010 a=0x00000000cb800000 f=0x0002
>         swapper/0-1     [003] ....     1.854101: remove_device_from_group: IOMMU: groupID=0 device=0000:00:02.0
>         swapper/0-1     [003] ....     1.854102: attach_device_to_domain: IOMMU: device=0000:00:02.0
>         swapper/0-1     [003] ....     1.854102: detach_device_from_domain: IOMMU: device=0000:00:02.0
>         swapper/0-1     [003] ....     1.854102: map: IOMMU: iova=0x00000000cb800000 paddr=0x00000000cf9fffff size=0x400
>         swapper/0-1     [003] ....     1.854102: unmap: IOMMU: iova=0x00000000cb800000 size=0x400
>

Any comments on this patch? Is this a reasonable approach?

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
