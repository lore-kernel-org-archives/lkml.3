Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3EFQGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:06:22 -0400
Received: from mail.datasphere.ch ([195.70.3.149]:35143 "EHLO
	mail.datasphere.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3EFQGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:06:20 -0400
X-Greylist: delayed 3127 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2013 12:06:20 EDT
Message-ID: <5187C8AB.90501@datasphere.ch>
Date: Mon, 06 May 2013 17:13:47 +0200
From: Patrick Monnerat <pm@datasphere.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Create megaraid ioctl device node
References: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01> <87a9o86vbj.fsf@nemi.mork.no>
In-Reply-To: <87a9o86vbj.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:23 PM, Bjørn Mork wrote:
> "Patrick Monnerat" <Patrick.Monnerat@datasphere.ch> writes:
>>    Create ioctl device node for megaraid_sas driver. Let this node be
>> managed by udev. Fix a typo.
>
> Or maybe just simplify it all and use a misc device instead?  See how
> this is done in e.g. drivers/scsi/mpt3sas/mpt3sas_ctl.c or
> drivers/message/fusion/mptctl.c

Yes, could be done that way, But I want to retain compatibility with 
existing shell scripts doing things like:

DEVICE=/dev/megaraid_sas_ioctl_node
DEVICENAME=megaraid_sas_ioctl
DEVICEPERM=400
MAJOR=`grep "$DEVICENAME" /proc/devices | awk '{print $1}'`

if [ -n "$MAJOR" -a ! -e "$DEVICE" ]; then
     mknod "$DEVICE" c "$MAJOR" 0
     chmod "$DEVICEPERM" "$DEVICE"
fi

Snippets like this one appear both in open-source projects and Dell scripts.

Patrick
