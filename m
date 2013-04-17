Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012Ab3DQKaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:30:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965826Ab3DQKaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:30:03 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Bastien Nocera <hadess@hadess.net>, Fabien <fabien.andre@gmail.com>,
        Jarod Wilson <jarod@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: appleir: add support for Apple ir devices
Date: Wed, 17 Apr 2013 12:30:52 +0200
Message-ID: <1614985.S6T7jXBLvD@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1366189389-6572-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1366189389-6572-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013 11:03:09 Benjamin Tissoires wrote:

> +static void appleir_remove(struct hid_device *hid)
> +{
> +       struct appleir *appleir = hid_get_drvdata(hid);
> +       del_timer_sync(&appleir->key_up_timer);
> +       hid_hw_stop(hid);
> +       kfree(appleir);
> +}

Hi,

this looks like a race condition. If you get input between
del_timer_sync() and hid_hw_stop() the timer may be restarted.
You need to stop the hw first.

	Regards
		Oliver

