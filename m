Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3FKGXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:23:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14222 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3FKGXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:23:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 10 Jun 2013 23:22:32 -0700
Message-ID: <51B6C271.2090001@nvidia.com>
Date: Tue, 11 Jun 2013 09:23:45 +0300
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mayuresh Kulkarni <mkulkarni@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tegra: add support for runtime pm
References: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com> <20130527154539.GD9460@mithrandir> <51A4445F.1000201@nvidia.com> <20130528091022.GB10934@mithrandir> <51ADA837.4020907@nvidia.com> <20130610204316.GC26036@mithrandir>
In-Reply-To: <20130610204316.GC26036@mithrandir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.06.2013 23:43, Thierry Reding wrote:
> Can you post the corresponding wrappers to make it easier to discuss
> them? If they just wrap runtime PM calls then they don't solve the
> locality problems that Terje brought up.

I don't think the wrappers are applicable here. They're there in
downstream to fix a problem with runtime PM core: some host1x clients
require host1x to be active when they're processing, and some (dc) need
it only when CPU is programming DC or when a signal towards host1x is
pending. Runtime PM wants to keep parent enabled when any of the clients
are enabled.

We solved this downstream by enabling ignore_children for host1x. As a
side effect, we need to explicitly enable host1x when we're enabling one
of its clients that need host1x, and that's what the wrapper does.

We can fix this particular problem by moving calls to runtime PM to job.c.

Mayuresh, once you've managed to test your patches, please send the v2.

Terje
