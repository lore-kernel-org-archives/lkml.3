Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3IHM1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:27:36 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:59028 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3IHM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:27:33 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.56.158]
In-Reply-To: <5220F099.1020002@nvidia.com>
References: <5220F099.1020002@nvidia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 8 Sep 2013 14:27:11 +0200
Message-ID: <CAK=WgbZ2JgtAonvdyeDZazYBGdKpPAieJtjzi7MM6nwqhVfs7g@mail.gmail.com>
Subject: Re: permission to move definition of struct rpmsg_channel_info
To: Arjun Gopalan <agopalan@nvidia.com>
Cc: Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjun,

On Fri, Aug 30, 2013 at 9:20 PM, Arjun Gopalan <agopalan@nvidia.com> wrote:
>
> Hi Ohad/Brian,
>
> I have been working on rpmsg and I need to be able to create static rpmsg channels. Channel information needs to be specified by other drivers and for this, the drivers need access to struct rpmsg_channel_info.

I'm not convinced how useful it is for other Linux drivers to create
static rpmsg channels?

Usually these channels reflect the existence of services running on
the remote processor, and their creation (or lack thereof) should be
specified in the remote image. This way an rpmsg channel is published
iff there is a matching remote service.

The way we were planning to add static channels functionality (I
should still have preliminary patches doing this somewhere but the
entire work was put on hold since TI changed its focus) is by
statically publishing them in the resource table, which is coupled
with a specific remote image.

Best,
Ohad.
