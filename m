Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaETOdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:33:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbaETOdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:33:17 -0400
Date: Tue, 20 May 2014 16:33:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: do not handle touchscreens through hid-rmi
In-Reply-To: <1398263514-7281-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1405201631310.1615@pobox.suse.cz>
References: <1398263514-7281-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Benjamin Tissoires wrote:

> Currently, hid-rmi drives every Synaptics product, but the touchscreens
> on the Windows tablets should be handled through hid-multitouch.
> 
> Instead of providing a long list of PIDs, rely on the scan_report
> capability to detect which should go to hid-multitouch, and which
> should not go to hid-rmi.
> 
> We introduce a generic HID_GROUP_HAVE_SPECIAL_DRIVER which can be reused
> amoung other drivers if they want to have a catch rule but still
> have multitouch devices handled through hid-multitouch.
> 
> related bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=74241
> https://bugzilla.redhat.com/show_bug.cgi?id=1089583
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Hi Benjamin,

sorry for not responding sooner.

Yes, I have to say I find HID_GROUP_HAVE_SPECIAL_DRIVER very disgusting. 
Especially its (non-)relation to hid_have_special_driver[] is very 
confusing.

If you could update this to be RMI-specific (i.e. create a special 
HID_GROUP for RMI devices), I'll merge it right away.

Thanks,

-- 
Jiri Kosina
SUSE Labs
