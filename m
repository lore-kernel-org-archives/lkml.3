Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaCKWSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:18:12 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:41027 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaCKWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF8ED5D@HASMSX106.ger.corp.intel.com>
References: <cover.1394304585.git.luto@amacapital.net> <9bdf4f25e7c57bccd20d7470271b7e385aac270a.1394304585.git.luto@amacapital.net>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF8ED5D@HASMSX106.ger.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Mar 2014 15:17:48 -0700
Message-ID: <CALCETrUGP==etEj-Um=d-AJLaQqxUBzjN-s_nfsWrEng7k5WrQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mei: Don't log an error when the MEI device is
 quirked off
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 3:03 AM, Winkler, Tomas <tomas.winkler@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Saturday, March 08, 2014 20:58
>> To: linux-kernel@vger.kernel.org
>> Cc: trivial@kernel.org; Andy Lutomirski; Winkler, Tomas
>> Subject: [PATCH 1/4] mei: Don't log an error when the MEI device is quirked off
>>
>> If an administrator wants to use MEI, they can search the logs for
>> 'mei'.  Otherwise they don't need a glaring reminder that their
>> hardware doesn't actually support MEI.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  drivers/misc/mei/pci-me.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
>> index ddadd08..809021e 100644
>> --- a/drivers/misc/mei/pci-me.c
>> +++ b/drivers/misc/mei/pci-me.c
>> @@ -127,7 +127,7 @@ static int mei_me_probe(struct pci_dev *pdev, const
>> struct pci_device_id *ent)
>>
>>       if (!mei_me_quirk_probe(pdev, ent)) {
>>               err = -ENODEV;
>> -             goto end;
>> +             return err;  /* No point in logging an error. */
>>       }
>
>
> I would like to have at least some info/debug message logged,
> the issue was discovered on specific DELL machines and there is a little worry
> that on some systems it can be false positive.

mei_me_quirk_probe logs "Device doesn't have valid ME Interface\n".

--Andy
