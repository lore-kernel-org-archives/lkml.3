Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaJCJ4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:56:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaJCJ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:56:01 -0400
Message-ID: <542E72A8.2030908@redhat.com>
Date: Fri, 03 Oct 2014 11:55:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] input: alps: Reset mouse and ALPS driver immediately
 after first invalid packet
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <1412329392-5580-4-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1412329392-5580-4-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/03/2014 11:43 AM, Pali Rohár wrote:
> For unknown reasons linux psmouse alps driver sometimes receive totally invalid
> packet sequences on Dell Latitude laptops. According to ALPS HW engineers these
> invalid packets do not come from ALPS devices. So it looks like bug in BIOS and
> EC incorrectly split keyboard and touchpad PS/2 data when laptops are under
> heavy loads (big I/O together with powersave governor, running on battery).
> 
> There are sequences of invalid packets (which are dropeed) and some sequences
> which look like valid. But these valid packets cause random trackstick button
> pressing, random cursor moving/jumping and in these condition it is not possible
> to use ALPS device (trackstick+touchpad).
> 
> To prevent random button press and random cursor jumps immediately reset ALPS
> device after first invalid packet. This will cause that touchpad and trackstick
> will not respond for one or two seconds and it better then random cursor jumps.
> 

This one probably should have:

Bug: https://bugzilla.redhat.com/show_bug.cgi?id=1145954

And you may want to add Bug: tags to the relevant patches for the
launchpad issues too.

While on the topic of tags, once we've agreed upon the return value to use for the
2nd patch, can you please resend with a "Cc: stable@vger.kernel.org" added to all
3 patches?

> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>

Looks good and seems sensible:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Thanks & Regards,

Hans
