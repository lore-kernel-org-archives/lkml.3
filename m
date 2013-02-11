Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3BKWbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:31:11 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59597 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab3BKWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:31:10 -0500
MIME-Version: 1.0
In-Reply-To: <5119706F.1080902@gmail.com>
References: <1360621157-23570-1-git-send-email-grant.likely@secretlab.ca> <5119706F.1080902@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 11 Feb 2013 22:30:49 +0000
X-Google-Sender-Auth: QlZ_Ty3_n7_4O56nkAsKqWW0EDs
Message-ID: <CACxGe6uv-DZ2u1eqnvo11mONuu95oPCnUZU_5JhqDz1-DXwkfQ@mail.gmail.com>
Subject: Re: [PATCH] of: Fix locking when calling of_get_next_available_child()
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 10:27 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 02/11/2013 04:19 PM, Grant Likely wrote:
>> of_get_next_available_child() obtains the devtree_lock and then calls
>> of_device_is_available() which also attempts to claim the lock. This is
>> obviously incorrect and causes a deadlock on boot. Fix issue by adding
>> an variant of of_device_is_available() which doesn't obtain the lock.
>>
>> Cc: Stephen Warren <swarren@wwwdotorg.org>
>> Cc: Rob Herring <robherring2@gmail.com>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  drivers/of/base.c |   15 +++++++++++++--
>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index e8d65af..4af74b7 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -297,7 +297,7 @@ EXPORT_SYMBOL(of_machine_is_compatible);
>>   *  Returns 1 if the status property is absent or set to "okay" or "ok",
>>   *  0 otherwise
>>   */
>> -int of_device_is_available(const struct device_node *device)
>> +int __of_device_is_available(const struct device_node *device)
>>  {
>>       const char *status;
>>       int statlen;
>> @@ -313,6 +313,17 @@ int of_device_is_available(const struct device_node *device)
>>
>>       return 0;
>>  }
>> +
>> +int of_device_is_available(const struct device_node *device)
>
> Stephen's version wins because he preserved the documentation. :)

Pish. He just cut and paste the documentation so now we have 2 copies.
My version wins because it is already in my tree. So ptfff!

:-)

g.
