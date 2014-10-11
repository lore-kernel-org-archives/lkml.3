Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaJKXed (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 19:34:33 -0400
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:56605 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbaJKXec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 19:34:32 -0400
X-Greylist: delayed 8400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2014 19:34:31 EDT
MIME-Version: 1.0
In-Reply-To: <20141011201523.GA29341@kroah.com>
References: <1413054822-7894-1-git-send-email-filipe@codinghighway.com>
	<20141011201523.GA29341@kroah.com>
Date: Sat, 11 Oct 2014 22:06:48 +0100
Message-ID: <CAECfEV8QWn9-JeSHcKpn7Hkaea0xzDxkGSzcLyrXa4vqdNnGcA@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/staging: Fixed sparse error "directive in
 argument list"
From: =?UTF-8?Q?Filipe_Gon=C3=A7alves?= <filipe@codinghighway.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 11234510746146540312
X-Ovh-Remote: 209.85.213.174 (mail-ig0-f174.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrleduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrleduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah .. right! I didn't know what OBD_OCD_VERSION() was. Now I see it's
a way to test kernel version. I am going to submit a new patch
shortly.

Thanks,
Filipe

On Sat, Oct 11, 2014 at 9:15 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Oct 11, 2014 at 08:13:42PM +0100, Filipe Gonçalves wrote:
>> This patch fixes a sparse warning on layout.c (ptlrpc) that was caused by having preprocessor directives in the arguments to a macro.
>>
>> Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
>> ---
>>  drivers/staging/lustre/lustre/ptlrpc/layout.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
>> index 5b83371..211df78 100644
>> --- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
>> +++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
>> @@ -978,10 +978,11 @@ struct req_msg_field RMF_CONN =
>>  EXPORT_SYMBOL(RMF_CONN);
>>
>>  struct req_msg_field RMF_CONNECT_DATA =
>> +#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
>>       DEFINE_MSGF("cdata",
>>                   RMF_F_NO_SIZE_CHECK /* we allow extra space for interop */,
>> -#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
>>                   sizeof(struct obd_connect_data),
>> +                 lustre_swab_connect, NULL);
>
> Ick ick ick.
>
> Yeah, sparse might complain about this, but how about just properly
> deleting the #ifdef entirely, and not perpetuate it even more?
>
> It shouldn't be needed anymore now that the code is in the kernel tree.
>
> greg k-h
