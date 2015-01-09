Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbbAIKbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:31:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbbAIKbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:31:01 -0500
Date: Fri, 9 Jan 2015 11:30:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: logitech-hidpp: store the name of the device in
 struct hidpp
In-Reply-To: <1420745832-7549-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1501091130360.15299@pobox.suse.cz>
References: <1420745832-7549-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Benjamin Tissoires wrote:

> If a disconnect occurs while getting the actual name of the device
> (which can take several HID transactions), the name of the device will
> be the hid name, provided by the Unifying Receiver.
> This means that in some cases, the user space will see a different
> name that what it usually sees when there is no disconnect.
> 
> We should store the name of the device in the struct hidpp. That way,
> if a disconnect occurs while we are accessing the name,
> hidpp_connect_event() can fail, and the input node is not created.
> 
> The input node will be created only if we have a connection which
> lasts long enough to retrieve all the requested information:
> name, protocol, and specific configuration.
> 
> Reviewed-by: Peter Wu <peter@lekensteyn.nl>
> Tested-by: Peter Wu <peter@lekensteyn.nl>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied to for-3.20/logitech.

Thanks,

-- 
Jiri Kosina
SUSE Labs
