Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaALMNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:13:55 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58139 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaALMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:13:53 -0500
Message-ID: <52D286FB.2070108@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 14:13:47 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagig@mellanox.com>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-8-git-send-email-nab@daterainc.com>	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2014 10:39 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:
> Sagi> What about FORMAT_UNIT emulation?  The backstore protection
> Sagi> configuration is done at the target side via configfs/targetcli,
>
> I don't know of any non-disk devices that actually implement FORMAT
> UNIT. Usually such configuration is done using the array management
> interface.
>

Hmm,

So this takes me to a corner I still don't understand, if a LUN is 
pre-formatted as T10-protected, what happens to unwritten blocks read?
I mean, SCSI login executes some reads from several LBAs which will 
probably fail as blocks are unwritten.

What is the usage model? perform Initiator login and then format the LUN 
on the target node? This is why I thought FORMAT_UNIT should be implemented.
I understand this corner will disappear in DIF v2 (following DIX1.1 
draft) with ESCAPE flags.
