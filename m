Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaFIBPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 21:15:07 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:60487 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbaFIBPC (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 21:15:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tz4oumjPD=bzBoJKkmhRA956a-FaNw2G+_zaO4kzWSEAQ@mail.gmail.com>
References: <53935504.1080903@symas.com>
	<CAPM=9tz4oumjPD=bzBoJKkmhRA956a-FaNw2G+_zaO4kzWSEAQ@mail.gmail.com>
Date: Sun, 8 Jun 2014 21:15:01 -0400
Message-ID: <CADnq5_NVZRpjpEGc1=mBDDs8bXEKaFkM93PCs-cQeHPDcyFRcg@mail.gmail.com>
Subject: Re: 3.12.9 kern.log spam from vgaswitcheroo
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Howard Chu <hyc@symas.com>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2014 at 4:18 PM, Dave Airlie <airlied@gmail.com> wrote:
> cc'ing list
>
> On 8 June 2014 04:08, Howard Chu <hyc@symas.com> wrote:
>> On Asus NP56D, if you use vgaswitcheroo to turn off the discrete GPU, the
>> kernel starts spewing these messages endlessly, until /var/log partition
>> fills up:
>>
>> Jun  7 17:40:27 gamba kernel: [470008.702322] [drm:radeon_cs_parser_init]
>> *ERROR* VM not ac
>> tive on asic!
>> Jun  7 17:40:27 gamba kernel: [470008.702325] [drm:radeon_cs_ioctl] *ERROR*
>> Failed to initi
>> alize parser !
>> Jun  7 17:40:27 gamba kernel: [470008.702385] [drm:radeon_cs_parser_init]
>> *ERROR* VM not ac
>> tive on asic!
>> Jun  7 17:40:27 gamba kernel: [470008.702389] [drm:radeon_cs_ioctl] *ERROR*
>> Failed to initi
>> alize parser !
>>
>> Turning the discrete GPU back on stops the stream of messages.

Something is trying to access the GPU while it's off.  Make sure your
version of mesa has this patch:
http://cgit.freedesktop.org/mesa/mesa/commit/?id=cf0172d46ab940a691da6516057c81f28961482f

Alex


>> --
>>   -- Howard Chu
>>   CTO, Symas Corp.           http://www.symas.com
>>   Director, Highland Sun     http://highlandsun.com/hyc/
>>   Chief Architect, OpenLDAP  http://www.openldap.org/project/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
