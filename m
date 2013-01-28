Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3A1PYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:24:25 -0500
Received: from host171.canaca.com ([67.55.55.225]:50597 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3A1PYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:24:22 -0500
Message-ID: <6b10e63f6686b4b0d05ec7ccd896f39e.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1301281601370.23853@pobox.suse.cz>
References: <1359095687-13398-1-git-send-email-simon@mungewell.org>
    <1359095687-13398-4-git-send-email-simon@mungewell.org>
    <alpine.LNX.2.00.1301281601370.23853@pobox.suse.cz>
Date: Mon, 28 Jan 2013 10:24:19 -0500
Subject: Re: [PATCH 4/4] USB: HID: SRW-S1 Add support controlling all LEDs
 simultaneously
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Simon Wood" <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, rosegardener@freeode.co.uk
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2013, Simon Wood wrote:
>
>> From: simon <simon@simon-virtual-machine.(none)>
>>
>> This patch to the SRW-S1 driver adds the ability to control all
>> LEDs simultaneously as testing showed that it was slow (noticably!!)
>> when seting or clearing all the LEDs in turn.
>>
>> It adds a 'RPMALL' LED, whose behavoir is asserted to all the LEDs in
>> the bar graph, individual LEDs can subsequently be turned on/off
>> individually.
>>
>> Signed-off-by: Simon Wood <simon@mungewell.org>
>> tested-by: John Murphy <rosegardener@freeode.co.uk>
> [ ... snip ... ]
>
>> @@ -219,13 +255,34 @@ static int srws1_probe(struct hid_device *hdev,
>>
>>  	/* register led subsystem */
>>  	drv_data->led_state = 0;
>> -	for (i = 0; i < SRWS1_NUMBER_LEDS; i++)
>> +	for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++)
>>  		drv_data->led[i] = NULL;
>>
>>  	srws1_set_leds(hdev, 0);
>>
>> -	name_sz = strlen(hdev->uniq) + 15;
>> +	name_sz = strlen(hdev->uniq) + 16;
>> +
>> +	/* 'ALL', for setting all LEDs simultaneously */
>> +	led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
>
> Is this memory ever freed?

Yes. The pointer to it is stored at the end of the drv_data leds[] array
(line 280), and will be free'd on probe fail (line 314) or when device is
removed (line 341).

Simon

