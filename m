Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966308Ab3DQSP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:15:56 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:37631 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965249Ab3DQSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:15:55 -0400
MIME-Version: 1.0
In-Reply-To: <516EE4BD.3000200@infradead.org>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au>
	<516EE4BD.3000200@infradead.org>
Date: Wed, 17 Apr 2013 21:15:54 +0300
Message-ID: <CAJZOPZJHJ0qKJo=HyEiJq1rRPXg+8bNh+8U_2WhX6FKbE2Km7A@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 17 (infiniband/rdma)
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 9:06 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 04/17/13 00:04, Stephen Rothwell wrote:
>> Changes since 20130416:

> on x86_64:
> drivers/built-in.o: In function `isert_free_np':
> ib_isert.c:(.text+0x6e8a77): undefined reference to `rdma_destroy_id'
[...]

Nic,

Yep, you need to add

depends on INET &&  INFINIBAND_ADDR_TRANS


to the isert Kconfig entry


This will make sure to get the rdma_cm to be configured and builts
whenever isert is

Or.
