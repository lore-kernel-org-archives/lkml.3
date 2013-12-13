Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3LMVA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:00:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab3LMVA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:00:57 -0500
Date: Fri, 13 Dec 2013 22:00:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] checkpatch: Attempt to find missing switch/case break;
In-Reply-To: <1386961580.2479.42.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1312132200040.12702@pobox.suse.cz>
References: <1386961580.2479.42.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Joe Perches wrote:

> Also tested on all files in drivers/hid/
> 
> There is a hit for drivers/hid/hid-microsoft.c
> 
> I've no idea what's right here but adding a break or return
> or a "fall-through" comment would be nicer.
> 
> static int ms_ergonomy_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
> 		unsigned long **bit, int *max)
> {
> 	struct input_dev *input = hi->input;
> 
> 	switch (usage->hid & HID_USAGE) {
> 	case 0xfd06: ms_map_key_clear(KEY_CHAT);	break;
> 	case 0xfd07: ms_map_key_clear(KEY_PHONE);	break;
> 	case 0xff05:
> 		set_bit(EV_REP, input->evbit);
> 		ms_map_key_clear(KEY_F13);
> 		set_bit(KEY_F14, input->keybit);
> 		set_bit(KEY_F15, input->keybit);
> 		set_bit(KEY_F16, input->keybit);
> 		set_bit(KEY_F17, input->keybit);
> 		set_bit(KEY_F18, input->keybit);
> 	default:
> 		return 0;
> 	}
> 	return 1;
> }

This is indeed a bug. I'll fix it with your Reported-by:, thanks.

-- 
Jiri Kosina
SUSE Labs
