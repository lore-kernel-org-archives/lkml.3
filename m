Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaEAVrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbaEAVrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:47:07 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Mateusz Guzik <mguzik@redhat.com>, devel@driverdev.osuosl.org,
        Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix potential leak in update_bcn_wps_ie()
References: <20140501135727.467d6bf2@spike>
	<20140501122216.GC1806@mguzik.redhat.com>
	<20140501221631.291a9c49@spike>
Date: Thu, 01 May 2014 23:46:57 +0200
In-Reply-To: <20140501221631.291a9c49@spike> (Christian Engelmayer's message
	of "Thu, 1 May 2014 22:16:31 +0200")
Message-ID: <wrfjtx99w4ry.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Engelmayer <cengelma@gmx.at> writes:
> On Thu, 1 May 2014 14:22:17 +0200, Mateusz Guzik <mguzik@redhat.com> wrote:
>> On Thu, May 01, 2014 at 01:57:27PM +0200, Christian Engelmayer wrote:
>> > Fix a potential leak in the error path of function update_bcn_wps_ie().
>> > Make sure that allocated memory for 'pbackup_remainder_ie' is freed
>> > upon return. Detected by Coverity - CID 1077718.
>> > 
>> 
>>         if (remainder_ielen > 0) {
>>                 pbackup_remainder_ie = kmalloc(remainder_ielen, GFP_ATOMIC);
>>                 if (pbackup_remainder_ie)
>>                         memcpy(pbackup_remainder_ie, premainder_ie,
>>                                remainder_ielen);
>>         }
>> 
>>         pwps_ie_src = pmlmepriv->wps_beacon_ie;
>>         if (pwps_ie_src == NULL)
>>                 return;
>> 
>> 
>> Maybe just check pwps_ie_src earlier?
>> 
>
> You are right, I see no reason why this cannot be done early in the function.

Looks good to me - if you send me a patch with a commit message and a
Signed-off-by, I'll add it to the rtl8723au driver tree and push it to
Greg with my next set of changes.

Cheers,
Jes
