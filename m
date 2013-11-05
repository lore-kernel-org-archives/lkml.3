Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3KEIIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:08:05 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:41576 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3KEIID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:08:03 -0500
Message-ID: <5278A741.6040206@rosalab.ru>
Date: Tue, 05 Nov 2013 12:07:29 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>
CC: Alexander Usyskin <alexander.usyskin@intel.com>,
        =?UTF-8?B?Tmljb2zDsiA=?= =?UTF-8?B?Q29zdGFuemE=?= 
	<abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mei: cancel stall timers in mei_reset
References: <1361817048.3583.1383580128332.JavaMail.root@collab.rosalab.ru>
In-Reply-To: <1361817048.3583.1383580128332.JavaMail.root@collab.rosalab.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 07:48 PM, Eugene Shatokhin wrote:
> ----- Original Message -----
>> I would appreciate the full log and your .config
>
> I have attached the config and the log.
>
> Meanwhile, I have found one suspicious place in the code that could be related: mei_reset() ignores the return value of mei_hw_start(). According to the logs, there was at least the following interesting call sequence before things went wrong:
>
> mei_reset() => mei_hw_start() => .hw_start() callback, which is mei_me_hw_start() => mei_me_hw_ready_wait().
>
> mei_me_hw_ready_wait() reported "wait hw ready failed" and returned -ETIMEDOUT, that error was propagated to mei_hw_start(). mei_reset(), however, does not check the return value of that function and goes on even if it returns an error: sets dev->dev_state to MEI_DEV_INIT_CLIENTS, calls mei_hbm_start_req(dev), etc.
>
> I am not sure if this is intentional and if this is related to the problem, but still.
>

Oh, looks like it is mei_hw_start() that first ignores the error. Might 
be a problem anyway.

Regards,
Eugene

-- 
Eugene Shatokhin, ROSA Laboratory.
www.rosalab.com
