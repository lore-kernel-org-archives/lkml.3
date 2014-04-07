Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaDGOEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbaDGOEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:04:20 -0400
Message-ID: <5342B059.1030401@redhat.com>
Date: Mon, 07 Apr 2014 09:04:09 -0500
From: Ken Cox <jkc@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, Jet Chen <jet.chen@intel.com>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
References: <20140407111725.GC25152@localhost>
In-Reply-To: <20140407111725.GC25152@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/07/2014 06:17 AM, Fengguang Wu wrote:
> Hi Ken,
>
> I got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> commit 12e364b9f08aa335dc7716ce74113e834c993765
> Author:     Ken Cox <jkc@redhat.com>
> AuthorDate: Tue Mar 4 07:58:07 2014 -0600
> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CommitDate: Tue Mar 4 16:58:21 2014 -0800
>
--snip--
> [   24.135101] FPGA image file name: xlinx_fpga_firmware.bit
> [   24.137595] GPIO INIT FAIL!!
> [   24.141283] driver version 1.0.0.0 loaded
> [   24.142539] chipset driver version 1.0.0.0 loadedinvalid opcode: 0000 [#1] PREEMPT SMP
> [   24.144793] Modules linked in:
> [   24.145303] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-00621-g12e364b #1
> [   24.145303] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   24.145303] task: ffff88001157a010 ti: ffff88001157c000 task.ti: ffff88001157c000
> [   24.145303] RIP: 0010:[<ffffffff81e37115>]  [<ffffffff81e37115>] visorchipset_init+0x7b/0x8c5
The problem is that the driver is trying to call firmware code that only 
exists on Unisys s-Par hardware.  I will add a check to make sure the 
driver is running on the correct platform before trying to call into the 
firmware.

