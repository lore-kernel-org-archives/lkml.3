Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3ETM2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:28:42 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:56039 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3ETM2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130515091248.00002fe3@unknown>
References: <1368586102-17661-1-git-send-email-yinghai@kernel.org>
	<20130515091248.00002fe3@unknown>
Date: Mon, 20 May 2013 15:28:39 +0300
Message-ID: <CAJZOPZ+L1QJdHePd_x9RAoqZKyJAKHo+hA8T1UZoe8=ozT98RA@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] PCI: Make sure VF's driver get attached after PF's
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Greg Rose <gregory.v.rose@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yan Burman <yanb@mellanox.com>, Sathya Perla <Sathya.Perla@emulex.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 7:12 PM, Greg Rose <gregory.v.rose@intel.com> wrote:


> I'm really not a fan of this.  Seems to me the tail is wagging the dog
> here.  Fix the driver to work without a PF driver being present.

Greg, Alex,

As I wrote over the V1 thread, currently we can't go and patch mlx4 to
use the sysfs API nor defer the call from within our probe function to
enable sriov since  this requires some firmware change to allow
enabling SRIOV after some  resources are initialized/provisioned.
Hence the patch suggested here or any other patch we can agree on
which will make sure that VF probing is done only once the PF is ready
is preferred, I think.

I wasn't sure to totally follow on the argument that things need to
work when the PF is absent in the sense there's no driver instance
around over which the PF is probed, if you can explain little better,
that would help.

Or.
