Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3KNTqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:46:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab3KNTp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:45:58 -0500
Date: Thu, 14 Nov 2013 12:45:49 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Erik Jacobson <erikj@sgi.com>,
        Andrew Morton <akpm@osdl.org>, Matt Helsley <matthltc@us.ibm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        zaitcev@redhat.com
Subject: Re: [PATCH] connector: improved unaligned access error fix
Message-ID: <20131114124549.7b5f3a7b@lembas.zaitcev.lan>
In-Reply-To: <201311141743.rAEHhuEV004998@farm-0012.internal.tilera.com>
References: <201311141743.rAEHhuEV004998@farm-0012.internal.tilera.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 12:09:21 -0500
Chris Metcalf <cmetcalf@tilera.com> wrote:

> -	__u8 buffer[CN_PROC_MSG_SIZE];
> +	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);

> -	msg = (struct cn_msg *)buffer;
> +	msg = buffer_to_cn_msg(buffer);
>  	ev = (struct proc_event *)msg->data;
>  	memset(&ev->event_data, 0, sizeof(ev->event_data));

Why is memset(buffer,0,CN_PROC_MSG_SIZE) not acceptable?

-- Pete
