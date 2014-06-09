Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaFINwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:52:08 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42926 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaFINwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:52:04 -0400
Message-ID: <5395BBFF.9070703@suse.cz>
Date: Mon, 09 Jun 2014 15:51:59 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johan Hedberg <johan.hedberg@intel.com>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 3.12 064/146] Bluetooth: Fix redundant encryption request
 for reauthentication
References: <cover.1402303820.git.jslaby@suse.cz> <b4afe9c6a39ffb4011c025ea6ecc4a99111beedd.1402303821.git.jslaby@suse.cz> <20140609133302.GA10377@t440s.lan>
In-Reply-To: <20140609133302.GA10377@t440s.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 03:33 PM, Johan Hedberg wrote:
> Hi,
> 
> On Mon, Jun 09, 2014, Jiri Slaby wrote:
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ===============
>>
>> commit 09da1f3463eb81d59685df723b1c5950b7570340 upstream.
>>
>> When we're performing reauthentication (in order to elevate the
>> security level from an unauthenticated key to an authenticated one) we
>> do not need to issue any encryption command once authentication
>> completes. Since the trigger for the encryption HCI command is the
>> ENCRYPT_PEND flag this flag should not be set in this scenario.
>> Instead, the REAUTH_PEND flag takes care of all necessary steps for
>> reauthentication.
>>
>> Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
>> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> ---
>>  net/bluetooth/hci_conn.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> This one seems to be causing a regression, so it's probably best to keep
> it out of stable trees for now:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=77541

Oh, thanks for letting me know. Now dropped.

thanks,
-- 
js
suse labs
