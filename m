Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab3DDHzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:55:20 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35735 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764249Ab3DDHzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:55:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1304040946170.30938@pobox.suse.cz>
References: <1364993121-18800-1-git-send-email-huzefa.nomanx.kankroliwala@intel.com>
	<alpine.LNX.2.00.1304040946170.30938@pobox.suse.cz>
Date: Thu, 4 Apr 2013 09:55:16 +0200
Message-ID: <CAN+gG=GuEuzekoMAsRiGJNs73PFzRK8oxjjRB4xP1kQeBp0DCw@mail.gmail.com>
Subject: Re: [PATCH v2] i2c-hid: fix length for set/get report in i2c hid
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>,
        mika.westerberg@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 9:47 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 3 Apr 2013, Huzefa Kankroliwala wrote:
>
>> With the current i2c hid driver set/get report does not work
>> as expected, for e.g sensor hub properties like power state,
>> frequency etc is not set properly on the device as a result
>> we do not get events.
>> The problem is that i2c hid driver in function i2c_hid_request
>> sets length equal to default buffer size for which the sensor
>> hub does not respond on get/set commands. Use report length
>> and calculate it based on report size and id.
>>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> Signed-off-by: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>
>
> This is based on some old version of the driver though. Could you please
> rebase it so that it applies on top of for-next branch of
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
>
> and resend? (actually rebasing on Linus' current tree would be absolutely
> sufficient).

Actually, the patch goes smoothly on your for-next branch on my computer...
And there is no point rebasing it on top of Linus' tree as the
i2c_hid_request() callback is scheduled for 3.10.

Could you double check Jiri?

Thanks,
Benjamin

>
> Thanks.
>
> --
> Jiri Kosina
> SUSE Labs
