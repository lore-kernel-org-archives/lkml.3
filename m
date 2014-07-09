Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaGIEuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:50:21 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:42274 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaGIEuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:50:19 -0400
Message-ID: <53BCC9B5.8080201@gmail.com>
Date: Wed, 09 Jul 2014 08:48:53 +0400
From: Anton Protopopov <a.s.protopopov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: gregkh <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, abbotti <abbotti@mev.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: check the return value of kobject_set_name
References: <1402149415-20037-1-git-send-email-a.s.protopopov@gmail.com> <5395860E.3070000@mev.co.uk> <CAGn_itzc_Lnu6qNTin6eDcBirJE3mHEp2_Ex+H6tqLA2OUBBjw@mail.gmail.com> <20140709042845.GA8664@kroah.com>
In-Reply-To: <20140709042845.GA8664@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



09.07.2014 08:28, gregkh пишет:
> On Wed, Jul 09, 2014 at 08:24:06AM +0400, Anton Protopopov wrote:
>> 2014-06-09 14:01 GMT+04:00 Ian Abbott <abbotti@mev.co.uk>:
>>> On 2014-06-07 14:56, Anton Protopopov wrote:
>>>>
>>>> Added a check of the return value of the kobject_set_name function.
>>>>
>>>> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
>>>> ---
>>>>   drivers/staging/comedi/comedi_fops.c | 9 ++++++++-
>>>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>>
>>> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>>
>> This patch was lost, I guess?
> 
> I don't seem to have it anymore in my inbox, please resend.
> 
> greg k-h
> 


Added a check of the return value of the kobject_set_name function.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 9d99fb3..dfeefa2 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2597,7 +2597,14 @@ static int __init comedi_init(void)
 		return -EIO;
 	cdev_init(&comedi_cdev, &comedi_fops);
 	comedi_cdev.owner = THIS_MODULE;
-	kobject_set_name(&comedi_cdev.kobj, "comedi");
+
+	retval = kobject_set_name(&comedi_cdev.kobj, "comedi");
+	if (retval) {
+		unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
+					 COMEDI_NUM_MINORS);
+		return retval;
+	}
+
 	if (cdev_add(&comedi_cdev, MKDEV(COMEDI_MAJOR, 0), COMEDI_NUM_MINORS)) {
 		unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
 					 COMEDI_NUM_MINORS);
-- 
1.8.3.4
