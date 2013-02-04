Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3BDJir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:38:47 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55705 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3BDJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:38:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130203130731.GA2677@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
	<20130203130731.GA2677@polaris.bitmath.org>
Date: Mon, 4 Feb 2013 10:38:44 +0100
Message-ID: <CAN+gG=GRS+fx4c3Kdba-89+ba8soimMm_rv7HDuaZLZWseQGuQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Support of Nexio 42" and new default class for hid-multitouch
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, Feb 3, 2013 at 2:07 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> so, this is the v2 of the support of win7/8 devices.
>
> Looks like it is getting there, thanks.

Thanks for the review. However, before sending a new patch series, I'd
like to have your answers to my comments as I mostly disagree on
everything :)

Thanks again,
Benjamin

>
>> changes since v1:
>> - removed the "optimization" patches, as the benefit was minimum
>> - introduce a new callback "report" in hid-core that drivers can use to treat the
>>   report by having it entirely parsed
>> - rely on this new hook to support Nexio 42"
>
> As noted in the patches comments, using raw_event() seems sufficient.
>
>> side notes:
>> - I've tested removing the heavy call to kzalloc in hid_input_field. The results
>>   are disapointing -> the processing time remains the same.
>> - I've also tested not to rely on .event hook in hid-multitouch but only on .report.
>>   Idem, I thought it would reduce the code of hid-multitouch and will enhance its
>>   processing time, but the results are a roughly same number of lines for hid-multitouch
>>   and the same processing time... :(
>> - these 2 tests helped in cleaning the patch set from the last time.
>>
>> And again, finally, I've pass all the 40 regression tests of my db. \o/
>
> Nice. :-)
>
> Thanks,
> Henrik
