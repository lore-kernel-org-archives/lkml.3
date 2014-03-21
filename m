Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbaCUJrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:47:14 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:47221 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965033AbaCUJq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:46:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140318231401.GA2459@kroah.com>
References: <1395181999-29433-1-git-send-email-eu@opreamatei.ro>
	<20140318231401.GA2459@kroah.com>
Date: Fri, 21 Mar 2014 11:46:57 +0200
Message-ID: <CABeAxacohJoL0NqBJmg3CKw=Ptcg=DFRZPyt9ExH0hD8J-E8iw@mail.gmail.com>
Subject: Re: [PATCH] staging: cxt1e1: hwprobe: Fix sparse warning
From: Matei Oprea <eu@opreamatei.ro>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: sachin.kamat@linaro.org, Shaun Laing <shaun@xresource.ca>,
        driverdev <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did it against your master branch of staging.git. I guess that's why
doesn't apply at all. I switched branches to staging-next after your
e-mail.

Thanks and sorry !

On Wed, Mar 19, 2014 at 1:14 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 19, 2014 at 12:33:19AM +0200, Matei Oprea wrote:
>> This fixes the following sparse warning:
>> * drivers/staging/cxt1e1/hwprobe.c:43:19:
>> warning: symbol 'hdw_info' was not declared. Should it be static?
>> * drivers/staging/cxt1e1/hwprobe.c:47:1:
>> warning: symbol 'show_two' was not declared. Should it be static?
>> * drivers/staging/cxt1e1/hwprobe.c:99:1:
>> warning: symbol 'hdw_sn_get' was not declared. Should it be static?
>> *drivers/staging/cxt1e1/hwprobe.c:149:1:
>> warning: symbol 'prep_hdw_info' was not declared. Should it be static?
>> * drivers/staging/cxt1e1/hwprobe.c:169:1:
>> warning: symbol 'cleanup_ioremap' was not declared. Should it be static?
>> * drivers/staging/cxt1e1/hwprobe.c:195:1:
>> warning: symbol 'cleanup_devs' was not declared. Should it be static?
>> drivers/staging/cxt1e1/hwprobe.c:293:1:
>> * warning: symbol 'c4hw_attach_all' was not declared. Should it be static?
>>
>> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
>> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
>> ---
>>  drivers/staging/cxt1e1/hwprobe.c |   14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
>> index 02b4f8f..694047a 100644
>> --- a/drivers/staging/cxt1e1/hwprobe.c
>> +++ b/drivers/staging/cxt1e1/hwprobe.c
>> @@ -40,10 +40,10 @@ void        c4_stopwd (ci_t *);
>>  struct net_device * __init c4_add_dev (hdw_info_t *, int, unsigned long, unsigned long, int, int);
>>
>>
>> -struct s_hdw_info hdw_info[MAX_BOARDS];
>> +static struct s_hdw_info hdw_info[MAX_BOARDS];
>>
>>
>> -void        __init
>> +static void        __init
>>  show_two (hdw_info_t *hi, int brdno)
>>  {
>>      ci_t       *ci;
>> @@ -95,7 +95,7 @@ show_two (hdw_info_t *hi, int brdno)
>
>
> This patch doesn't apply at all, did you do it against my staging-next
> branch of staging.git or linux-next?  Or did you do it against Linus's
> tree?  If Linus's tree, that's quite "old" for development stuff, always
> work against linux-next to avoid making the same changes others already
> have in the past.
>
> greg k-h



-- 
Oprea Matei

ᐧ
