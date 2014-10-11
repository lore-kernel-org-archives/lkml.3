Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaJKVtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 17:49:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:26507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaJKVtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 17:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,701,1406617200"; 
   d="scan'208";a="617088077"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: =?iso-8859-1?Q?Filipe_Gon=E7alves?= <filipe@codinghighway.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        devel <devel@driverdev.osuosl.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers/staging: Fixed sparse error "directive in
 argument list"
Thread-Topic: [PATCH 1/1] drivers/staging: Fixed sparse error "directive in
 argument list"
Thread-Index: AQHP5YeLBRjZPZ743UK3w+b4HkdI/5wrynaAgAAOXQCAAAvXAA==
Date: Sat, 11 Oct 2014 21:49:10 +0000
Message-ID: <72868F07-0853-4F23-9361-AE2F49B0F986@intel.com>
References: <1413054822-7894-1-git-send-email-filipe@codinghighway.com>
 <20141011201523.GA29341@kroah.com>
 <CAECfEV8QWn9-JeSHcKpn7Hkaea0xzDxkGSzcLyrXa4vqdNnGcA@mail.gmail.com>
In-Reply-To: <CAECfEV8QWn9-JeSHcKpn7Hkaea0xzDxkGSzcLyrXa4vqdNnGcA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.24.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <0D221608427C4A41BD208E288CE32DFD@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

   No, it's not the way to test the kernel version, it's the way to test internal
   lustre version.
   Either way maintaining compatibility with Lustre 1.8 and 2.0 servers should not
   be important anymore, so it's fine to drop this check indeed.

Bye,
    Oleg
On Oct 11, 2014, at 5:06 PM, Filipe Gonçalves wrote:

> Ah .. right! I didn't know what OBD_OCD_VERSION() was. Now I see it's
> a way to test kernel version. I am going to submit a new patch
> shortly.
> 
> Thanks,
> Filipe
> 
> On Sat, Oct 11, 2014 at 9:15 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> 
>> On Sat, Oct 11, 2014 at 08:13:42PM +0100, Filipe Gonçalves wrote:
>>> This patch fixes a sparse warning on layout.c (ptlrpc) that was caused by having preprocessor directives in the arguments to a macro.
>>> 
>>> Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
>>> ---
>>> drivers/staging/lustre/lustre/ptlrpc/layout.c | 7 +++++--
>>> 1 file changed, 5 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
>>> index 5b83371..211df78 100644
>>> --- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
>>> +++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
>>> @@ -978,10 +978,11 @@ struct req_msg_field RMF_CONN =
>>> EXPORT_SYMBOL(RMF_CONN);
>>> 
>>> struct req_msg_field RMF_CONNECT_DATA =
>>> +#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
>>>      DEFINE_MSGF("cdata",
>>>                  RMF_F_NO_SIZE_CHECK /* we allow extra space for interop */,
>>> -#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
>>>                  sizeof(struct obd_connect_data),
>>> +                 lustre_swab_connect, NULL);
>> 
>> Ick ick ick.
>> 
>> Yeah, sparse might complain about this, but how about just properly
>> deleting the #ifdef entirely, and not perpetuate it even more?
>> 
>> It shouldn't be needed anymore now that the code is in the kernel tree.
>> 
>> greg k-h

