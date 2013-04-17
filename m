Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3DQQJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab3DQQJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:09:08 -0400
Message-ID: <516EC8C9.8040000@redhat.com>
Date: Wed, 17 Apr 2013 18:07:37 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Bastien Nocera <hadess@hadess.net>, Fabien <fabien.andre@gmail.com>,
        Jarod Wilson <jarod@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: appleir: add support for Apple ir devices
References: <1366189389-6572-1-git-send-email-benjamin.tissoires@redhat.com> <1614985.S6T7jXBLvD@linux-5eaq.site>
In-Reply-To: <1614985.S6T7jXBLvD@linux-5eaq.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 12:30 PM, Oliver Neukum wrote:
> On Wednesday 17 April 2013 11:03:09 Benjamin Tissoires wrote:
> 
>> +static void appleir_remove(struct hid_device *hid)
>> +{
>> +       struct appleir *appleir = hid_get_drvdata(hid);
>> +       del_timer_sync(&appleir->key_up_timer);
>> +       hid_hw_stop(hid);
>> +       kfree(appleir);
>> +}
> 
> Hi,
> 
> this looks like a race condition. If you get input between
> del_timer_sync() and hid_hw_stop() the timer may be restarted.
> You need to stop the hw first.
> 

ouch. Thanks for spotting this.
Will send a v3 soon.

Cheers,
Benjamin

