Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaE0AVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:21:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaE0AVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:21:46 -0400
Message-ID: <5383DA98.5010300@techfak.uni-bielefeld.de>
Date: Tue, 27 May 2014 02:21:44 +0200
From: Robert Abel <rabel@techfak.uni-bielefeld.de>
Reply-To: rabel@techfak.uni-bielefeld.de
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.14: WARNING: sysfs group ffffffff81c50ca0 not found for kobject
 'target5:0:0'
References: <20140516171842.GA4610@aepfle.de>
In-Reply-To: <20140516171842.GA4610@aepfle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olaf,

On 16.05.2014 19:18, Olaf Hering wrote:
> I did unplug an USB stick by accident with 3.14.4, the result is this
> warning:
>
>
> [94414.233882] usb 1-3: USB disconnect, device number 4
> [94414.245377] scsi 5:0:0:0: rejecting I/O to offline device
> [94414.245383] scsi 5:0:0:0: killing request
> [94414.370354] FAT-fs (sdc1): unable to read boot sector to mark fs as 
> dirty
> [94414.370393] ------------[ cut here ]------------
> [94414.370400] WARNING: CPU: 2 PID: 3619 at fs/sysfs/group.c:216 
> sysfs_remove_group+0xa1/0xb0()
> [94414.370403] sysfs group ffffffff81c50ca0 not found for kobject 
> 'target5:0:0'
This [1] might fix the problem you encountered. I reckon one of your 
drivers exposes a binary attribute file in a named attribute group, 
which it tries to remove when being unloaded. However, the path it looks 
for this attribute file is likely wrong.

     [1] http://comments.gmane.org/gmane.linux.kernel/1684070
