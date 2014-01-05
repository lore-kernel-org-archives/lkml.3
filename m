Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaAEM6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 07:58:50 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60733 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAEM6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 07:58:48 -0500
Message-ID: <52C956E9.2030008@gmail.com>
Date: Sun, 05 Jan 2014 14:58:17 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, pali.rohar@gmail.com,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] ARM: OMAPFB: panel-sony-acx565akm: fix missing mutex
 unlocks
References: <1388420272-5132-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20140104125108.GA22339@amd.pavel.ucw.cz>
In-Reply-To: <20140104125108.GA22339@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.01.2014 14:51, Pavel Machek wrote:
> On Mon 2013-12-30 18:17:52, Ivaylo Dimitrov wrote:
>> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>>
>> Commit c37dd677988ca50bc8bc60ab5ab053720583c168 fixes the unbalanced
>> unlock in acx565akm_enable but introduces another problem - if
>> acx565akm_panel_power_on exits early, the mutex is not unlocked. Fix
>> that by unlocking the mutex on early return. Also add mutex protection in
>> acx565akm_panel_power_off and remove an unused variable
>>
>> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Hmm, I introduced a bug with that patch (recursive lock), will send a 
new version that fixes it

Regards,
Ivo
