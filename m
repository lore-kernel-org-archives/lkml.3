Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaKDKLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:11:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaKDKLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:11:42 -0500
Date: Tue, 4 Nov 2014 11:11:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] HID: logitech-hidpp: fix negated returns
In-Reply-To: <1415048999-4490-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1411041111190.19451@pobox.suse.cz>
References: <1415048999-4490-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Benjamin Tissoires wrote:

> Reported by Dan Carpenter:
> 
> drivers/hid/hid-logitech-hidpp.c:359 hidpp_root_get_protocol_version() warn: should this return really be negated?
> drivers/hid/hid-logitech-hidpp.c:398 hidpp_devicenametype_get_count() warn: should this return really be negated?
> drivers/hid/hid-logitech-hidpp.c:417 hidpp_devicenametype_get_device_name() warn: should this return really be negated?
> drivers/hid/hid-logitech-hidpp.c:524 hidpp_touchpad_get_raw_info() warn: should this return really be negated?
> 
> The problem lies in hidpp_send_message_sync() which can return 2 types of
> errors depending of their sign. Adding a comment there to clarify what is
> happening.
> 
> To solve that, print an error in case of a protocol problem, and raise
> -EPROTO instead.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Changes in v2:
> - also return if the ret code is negative

Applied.

-- 
Jiri Kosina
SUSE Labs
