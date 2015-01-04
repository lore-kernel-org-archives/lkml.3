Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbbADPDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 10:03:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24855 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbADPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 10:03:46 -0500
Message-ID: <54A9563F.3070902@oracle.com>
Date: Sun, 04 Jan 2015 10:03:27 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "open list:VIRTIO CORE, NET..." 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/2] virtio: don't free memory until the underlying struct
 device has been released
References: <1420228060-18721-1-git-send-email-sasha.levin@oracle.com> <1420228060-18721-2-git-send-email-sasha.levin@oracle.com> <20150104112641.GB4336@redhat.com>
In-Reply-To: <20150104112641.GB4336@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2015 06:26 AM, Michael S. Tsirkin wrote:
> On Fri, Jan 02, 2015 at 02:47:40PM -0500, Sasha Levin wrote:
>> > When releasing a virtio device, We can't free a struct virtio_device until the
>> > underlying struct device has been released, which might not happen immediately
>> > on device_unregister() even if that was the device's last reference.
>> > 
>> > Instead, free the memory only once we know the device is gone in the release
>> > callback.
>> > 
>> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> Isn't this an old bug: do we need to copy stable on a fix?
> 
> What is the behaviour without this patch?
> Is there a way to make this cause a crash?

It will oops if CONFIG_DEBUG_KOBJECT_RELEASE is enabled. I guess
it needs to go to stable as well.


Thanks,
Sasha

