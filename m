Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaJTVKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:10:38 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:55935 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaJTVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141020153707.GX26918@mwanda>
References: <1413670390-6259-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141020153707.GX26918@mwanda>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 20 Oct 2014 23:10:09 +0200
Message-ID: <CAFo99gYAcfa47CLkQWLs7V8gTEOZfSOSXmjVC_3j_8Ugw4xk4w@mail.gmail.com>
Subject: Re: [PATCH 2/5] scsi: bfa: bfa_fcs_lport.c: Cleaning up missing
 null-terminate by switching from strncpy to strzcpy
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-20 17:37 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Oct 19, 2014 at 12:13:10AM +0200, Rickard Strandqvist wrote:
>> Ensures that the string is null-terminate in connection with the
>> use of strncpy, by switching from strncpy to strzcpy.
>>
>
> I wish the changelogs were more clear that we have no reason to think
> this is a real issue.
>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
>> index ff75ef8..78af89e 100644
>> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
>> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
>> @@ -2633,7 +2633,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
>>       strncpy(hba_attr->driver_version, (char *)driver_info->version,
>>               sizeof(hba_attr->driver_version));
>
> Why do we not change this one?
>
>>
>> -     strncpy(hba_attr->os_name, driver_info->host_os_name,
>> +     strzcpy(hba_attr->os_name, driver_info->host_os_name,
>>               sizeof(hba_attr->os_name));
>
> strlcpy() would also be totally safe here.  It's also safe for patch
> patch 3 and patch 4.  Patch 5 is trickier to audit so I don't know if
> strlcpy() is safe.


Hi Dan

It was a miss, should have done this on both strncpy.

After becoming quite attacked for having changed to strlcpy I am very
careful with it now.
But ok, then I submit 2 3 4 with strlcpy instead.

But this is a little bad example for strzcpy though :-(

Kind regards
Rickard Strandqvist
