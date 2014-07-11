Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaGKVmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:42:49 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:62982 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaGKVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:42:47 -0400
MIME-Version: 1.0
In-Reply-To: <1405029027-6085-12-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	<1405029027-6085-12-git-send-email-oded.gabbay@amd.com>
Date: Sat, 12 Jul 2014 07:42:45 +1000
Message-ID: <CAPM=9tyV8PBreHHSsMKo8dRiGvVWHR+LLPcNE2dVpoYkftpv2Q@mail.gmail.com>
Subject: Re: [PATCH 13/83] hsa/radeon: Add 2 new IOCTL to kfd, CREATE_QUEUE
 and DESTROY_QUEUE
From: Dave Airlie <airlied@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>, Ben Goz <ben.goz@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* The 64-bit ABI is the authoritative version. */
> +#pragma pack(push, 8)
> +

Don't do this, pad and align things explicitly in structs.

> +struct kfd_ioctl_create_queue_args {
> +       uint64_t ring_base_address;     /* to KFD */
> +       uint32_t ring_size;             /* to KFD */
> +       uint32_t gpu_id;                /* to KFD */
> +       uint32_t queue_type;            /* to KFD */
> +       uint32_t queue_percentage;      /* to KFD */
> +       uint32_t queue_priority;        /* to KFD */
> +       uint64_t write_pointer_address; /* to KFD */
> +       uint64_t read_pointer_address;  /* to KFD */
> +
> +       uint64_t doorbell_address;      /* from KFD */
> +       uint32_t queue_id;              /* from KFD */
> +};
> +

maybe put all the uint64_t at the start, or add explicit padding.

Dave.
