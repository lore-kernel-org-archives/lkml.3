Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaETO7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaETO7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:59:33 -0400
Date: Tue, 20 May 2014 14:59:16 +0000
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: do not handle touchscreens through hid-rmi
Message-ID: <20140520145916.GB9028@mail.corp.redhat.com>
References: <1398263514-7281-1-git-send-email-benjamin.tissoires@redhat.com>
 <alpine.LNX.2.00.1405201631310.1615@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405201631310.1615@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 20 2014 or thereabouts, Jiri Kosina wrote:
> On Wed, 23 Apr 2014, Benjamin Tissoires wrote:
> 
> > Currently, hid-rmi drives every Synaptics product, but the touchscreens
> > on the Windows tablets should be handled through hid-multitouch.
> > 
> > Instead of providing a long list of PIDs, rely on the scan_report
> > capability to detect which should go to hid-multitouch, and which
> > should not go to hid-rmi.
> > 
> > We introduce a generic HID_GROUP_HAVE_SPECIAL_DRIVER which can be reused
> > amoung other drivers if they want to have a catch rule but still
> > have multitouch devices handled through hid-multitouch.
> > 
> > related bug:
> > https://bugzilla.kernel.org/show_bug.cgi?id=74241
> > https://bugzilla.redhat.com/show_bug.cgi?id=1089583
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> Hi Benjamin,
> 
> sorry for not responding sooner.

It's not a big deal. Actually, the Canonical folks reminded me the state
of this patch that I completely forgot too :)

> 
> Yes, I have to say I find HID_GROUP_HAVE_SPECIAL_DRIVER very disgusting. 
> Especially its (non-)relation to hid_have_special_driver[] is very 
> confusing.
> 
> If you could update this to be RMI-specific (i.e. create a special 
> HID_GROUP for RMI devices), I'll merge it right away.

Ok, I'll add this to the pile of things to do today.

Cheers,
Benjamin
