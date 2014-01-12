Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaALL4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 06:56:23 -0500
Received: from mail-ee0-f67.google.com ([74.125.83.67]:61090 "EHLO
	mail-ee0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaALL4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 06:56:20 -0500
Message-ID: <52D282E0.2060800@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 13:56:16 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@mellanox.com>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	 <1389212157-14540-10-git-send-email-nab@daterainc.com>	 <52CE817B.9070203@mellanox.com> <1389337238.5567.408.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1389337238.5567.408.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2014 9:00 AM, Nicholas A. Bellinger wrote:
> On Thu, 2014-01-09 at 13:01 +0200, Sagi Grimberg wrote:
>> On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>
>>> This patch adds support for exposing DIF protection device
>>> attributes via configfs.  This includes:
>>>
>>>      pi_prot_type: Protection Type (0, 1, 3 currently support)
>>>      pi_prot_version: Protection Version (DIF v1 currently supported)
>>>      pi_guard_type: Guard Type (1=DIF CRC, 2=IP CRC)
>>>
>>> Within se_dev_set_pi_prot_type() it also adds the se_subsystem_api
>>> device callbacks to setup per device protection information.
>> Suggestion, expose pi_prot_format and call transport->init_prot() there.
>> It is more explicit
>> and this routine should be called upon getting FORMAT_UNIT as well.
> <nod>, working on this next for FILEIO following your original example
> code.

I would suggest to keep user interface the same for all backstores.
Let me send you my latest WIP example for FILEIO that follows the 
pi_prot_format notation and you can arrange it as you wish.

> Thanks Sagi!
>
> --nab
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

