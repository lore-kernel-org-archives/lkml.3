Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3KEJ6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:58:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:22149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab3KEJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:58:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,638,1378882800"; 
   d="scan'208";a="428088964"
From: "Usyskin, Alexander" <alexander.usyskin@intel.com>
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
CC: =?utf-8?B?Tmljb2zDsiBDb3N0YW56YQ==?= <abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: mei: cancel stall timers in mei_reset
Thread-Topic: mei: cancel stall timers in mei_reset
Thread-Index: AQHO1v25SuqUoX7R9021oFgYVQgsvJoTBDKAgAIW/gCAARFxgIAAP5xA
Date: Tue, 5 Nov 2013 09:58:25 +0000
Message-ID: <C980C034A53E0646B96866D6CE3D187A3330D460@HASMSX106.ger.corp.intel.com>
References: <1361817048.3583.1383580128332.JavaMail.root@collab.rosalab.ru>
 <5278A741.6040206@rosalab.ru>
In-Reply-To: <5278A741.6040206@rosalab.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA59x2ob016572

Hi

The problem that you found was fixed in patch here: https://lkml.org/lkml/2013/6/23/169
And this patch merged into 3.11 according to http://lxr.free-electrons.com/source/drivers/misc/mei/mei_dev.h?v=3.11
Can you re-check with latest 3.11 point release?


Thanks
--
Sasha

-----Original Message-----
From: Eugene Shatokhin [mailto:eugene.shatokhin@rosalab.ru] 
Sent: Tuesday, November 05, 2013 10:07
To: Winkler, Tomas
Cc: Usyskin, Alexander; NicolÃ² Costanza; Alex Burmashev; LKML
Subject: Re: mei: cancel stall timers in mei_reset

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
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
